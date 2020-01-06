# Copyright (C) 2006-2020 CS-SI
# License: GNU GPL v2 <http://www.gnu.org/licenses/gpl-2.0.html>

# Import de la couche de compatibilité.
. "`dirname $0`/../compat.sh"

if [ -z "$CONN_INFO" ]; then
    echo "La variable CONN_INFO n'est pas déclarée." >&2
    exit 1
fi

# @FIXME On ne devrait pas avoir recours à ce "sniffing".
case "$DISTRO" in
    mandriva)
        service=postgresql
        PG_HBA=/var/lib/pgsql/data/pg_hba.conf
        ;;
    redhat)
        service="postgresql"
        PG_HBA=/var/lib/pgsql/data/pg_hba.conf
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
if [ $RET -eq 0 ]; then
    # Rien de plus à faire, le service est déjà fonctionnel.
    :
elif [ -f /usr/bin/postgresql-setup ]; then
    # Cas d'une distribution utilisant systemd.
    /usr/bin/postgresql-setup initdb &> /dev/null
else
    # Cas d'une distribution utilisant initrc.
    service $service initdb &> /dev/null
fi
service $service start || exit $?

#postgresql://user:mdp@hote:port/base?arg1=val1&argN=valN
# L'expression régulière éclate la valeur pour obtenir
# les différents champs (un par ligne).
while true; do
    read dbuser
    read dbpass
    read dbhost
    read dbport
    read dbname
    read args
    break
done < <(grep '^sqlalchemy_url' /etc/vigilo/models/settings.ini | \
         sed -nre 's,^.*://([^:]+):([^@]+)@([^:/]*)(:([0-9]+))?/([^?]+)(\?([^#]*))?(#.*)?$,\1\n\2\n\3\n\5\n\6\n\8,p')

if [ -n "$args" ]; then
    while true; do
        read var_name
        read var_value

        var_value=`printf "%s" "$var_$value" | perl -pe 's/\%(\w\w)/chr hex $1/ge'`
        case "$var_name" in
            user)       dbuser="$var_value";;
            password)   dbpass="$var_value";;
            dbname)     dbname="$var_value";;
            host)       dbhost="$var_value";;
            port)       dbport="$var_value";;
        esac
    done < <(printf "%s" "$args" | sed -nre 's,[&=],\n,gp')
fi

# Il faut obligatoirement un nom d'utilisateur et un mot de passe.
[ -n "$dbuser" -a -n "$dbpass" -a -n "$dbname" ]

echo "Base de données           : $dbname"
echo "Utilisateur               : $dbuser"
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
su -c "psql -A -t -c '\du' \"$CONN_INFO\"" postgres | grep -qs '^'$dbuser || \
    su -c "psql -c \"CREATE ROLE $dbuser PASSWORD '$dbpass' NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;\" \"$CONN_INFO\"" postgres

# Base de données
if ! su -c "psql -A -t -l \"$CONN_INFO\"" postgres | grep -qs '^'$dbname; then
    su -c "createdb $dbname --owner $dbuser --encoding UTF8 -T template0 \"$CONN_INFO\"" postgres || exit $?
    echo "Création des tables dans la base de données PostgreSQL"
    vigilo-updatedb
fi
