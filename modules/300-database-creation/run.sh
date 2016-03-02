# Copyright (C) 2006-2016 CS-SI
# License: GNU GPL v2 <http://www.gnu.org/licenses/gpl-2.0.html>

# Import de la couche de compatibilité.
. "`dirname $0`/../compat.sh"
case "$DISTRO" in
    mandriva)
        service=postgresql
        PG_HBA=/var/lib/pgsql/data/pg_hba.conf
        ;;
    redhat)
        service="postgresql-9.2"
        PG_HBA=/var/lib/pgsql/9.2/data/pg_hba.conf
        ;;
    debian)
        service=postgresql
        PG_HBA=/etc/postgresql/9.1/main/pg_hba.conf
        ;;
    *)
        service=postgresql
        PG_HBA=/var/lib/pgsql/data/pg_hba.conf
        echo "ATTENTION : distribution inconnue."
        echo "Les valeurs suivantes seront utilisées :"
        echo "    service=$service"
        echo "    PG_HBA=$PG_HBA"
        echo "Appuyez sur Entrée pour continuer."
        read unused
        ;;
esac

echo "Création de la base de données PostgreSQL"
change_svc $service on
service $service status &> /dev/null
RET=$?
if [ "$RET" == "0" ]; then
    :
else
    service $service initdb &> /dev/null
    service $service start || exit $?
fi

#postgresql://user:mdp@hote:port/base
# L'expression régulière éclate la valeur pour obtenir
# les différents champs (un par ligne).
# Le port est optionnel et vaut 5432 si omis.
while true; do
    read dbuser
    read dbpass
    read dbhost
    read dbport
    if [ -z "$dbport" ]; then
        dbport=5432
    fi
    read dbname
    break
done < <(grep '^sqlalchemy_url' /etc/vigilo/models/settings.ini | \
         sed -re 's,^.*://([^:]+):([^@]+)@([^:/]+)(:([0-9]+))?/(.*)$,\1\n\2\n\3\n\5\n\6,')

[ -n "$dbuser" -a -n "$dbpass" -a -n "$dbhost" -a -n "$dbname" ]
echo "Base configurée: $dbname. Utilisateur configuré: $dbuser."
sleep 5

# Autoriser les connexions de l'utilisateur Vigilo
if [ -f "$PG_HBA" ]; then
    if ! grep -qs vigilo "$PG_HBA"; then
        echo "Attention, l'utilisateur vigilo n'est pas autorisé à se connecter à la base de données. Je l'ajoute, mais il faudra vérifier les permissions dans $PG_HBA" | fmt
        sed -i -e "/^# TYPE\s\+DATABASE\s\+USER\s\+\(CIDR-\)\?ADDRESS\s\+METHOD\s*$/a host $dbname $dbuser ::1/128 md5" "$PG_HBA"
        sed -i -e "/^# TYPE\s\+DATABASE\s\+USER\s\+\(CIDR-\)\?ADDRESS\s\+METHOD\s*$/a host $dbname $dbuser 127.0.0.1/32 md5" "$PG_HBA"
        sed -i -e "/^# TYPE\s\+DATABASE\s\+USER\s\+\(CIDR-\)\?ADDRESS\s\+METHOD\s*$/a #Access to vigilo database" "$PG_HBA"
        service $service reload
    fi
fi


# Utilisateur
su -c "psql -p $dbport -h '$dbhost' -A -t -c '\du'" postgres | grep -qs '^'$dbuser || \
    su -c "psql -p $dbport -h '$dbhost' -c \"CREATE ROLE $dbuser PASSWORD '$dbpass' \
           NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;\"" postgres

# Base de données
if ! su -c "psql -p $dbport -h '$dbhost' -A -t -l" postgres | grep -qs '^'$dbname; then
    su -c "createdb -p $dbport -h '$dbhost' $dbname --owner $dbuser --encoding UTF8 \
           -T template0" postgres || exit $?
    echo "Création des tables dans la base de données PostgreSQL"
    vigilo-updatedb
fi
