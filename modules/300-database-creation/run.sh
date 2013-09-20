# Copyright (C) 2006-2013 CS-SI
# License: GNU GPL v2 <http://www.gnu.org/licenses/gpl-2.0.html>

# Import de la couche de compatibilité.
. "`dirname $0`/../compat.sh"

echo "Création de la base de données PostgreSQL"
service=postgresql
change_svc $service on
service $service status &> /dev/null
RET=$?
if [ "$RET" == "0" ]; then
    :
else
    service $service initdb &> /dev/null
    service $service start || exit $?
fi

#postgresql://user:mdp@127.0.0.1/base
dbuser=`  grep '^sqlalchemy_url' /etc/vigilo/models/settings.ini | sed -e 's,^.*://\([^:]\+\):.*$,\1,'          | tail -n 1`
dbpasswd=`grep '^sqlalchemy_url' /etc/vigilo/models/settings.ini | sed -e 's,^.*://[^:]\+:\([^@]\+\)@.*$,\1,'   | tail -n 1`
dbname=`  grep '^sqlalchemy_url' /etc/vigilo/models/settings.ini | sed -e 's,^.*/\([^/]\+\)$,\1,'               | tail -n 1`

[ -n "$dbname" -a -n "$dbuser" -a -n "$dbpasswd" ]
echo "Base configurée: $dbname. Utilisateur configuré: $dbuser."
sleep 5


# Autoriser les connexions de l'utilisateur Vigilo
if [ -f "$PG_HBA" ]; then
    if ! grep -qs vigilo "$PG_HBA"; then
        echo "Attention, l'utilisateur vigilo n'est pas autorisé à se connecter à la base de données. Je l'ajoute, mais il faudra vérifier les permissions dans $PG_HBA" | fmt
        sed -i -e "/^# TYPE\s\+DATABASE\s\+USER\s\+\(CIDR-\)\?ADDRESS\s\+METHOD\s*$/a host $dbname $dbuser ::1/128 md5" "$PG_HBA"
        sed -i -e "/^# TYPE\s\+DATABASE\s\+USER\s\+\(CIDR-\)\?ADDRESS\s\+METHOD\s*$/a host $dbname $dbuser 127.0.0.1/32 md5" "$PG_HBA"
        sed -i -e "/^# TYPE\s\+DATABASE\s\+USER\s\+\(CIDR-\)\?ADDRESS\s\+METHOD\s*$/a #Access to vigilo database" "$PG_HBA"
        service postgresql reload
    fi
fi


# Utilisateur
su -c "psql -A -t -c '\du'" postgres | grep -qs '^'$dbuser || \
    su -c "psql -c \"CREATE ROLE $dbuser PASSWORD '$dbpasswd' NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;\"" postgres

# Base de données
if ! su -c 'psql -A -t -l' postgres | grep -qs '^'$dbname; then
    su -c "createdb $dbname --owner $dbuser --encoding UTF8 -T template0" postgres || exit $?
    echo "Création des tables dans la base de données PostgreSQL"
    mkdir -p log
    vigilo-updatedb || exit $?
    echo "(Désactivé) Remplissage de la base de données PostgreSQL"
    #vigilo-models-demo example1
    rm -rf log
fi
