#!/bin/sh
# Copyright (C) 2006-2012 CS-SI
# License: GNU GPL v2 <http://www.gnu.org/licenses/gpl-2.0.html>

echo "Création de la base de données PostgreSQL"
service=postgresql
chkconfig $service on
service $service status &> /dev/null
RET=$?
if [ "$RET" == "0" ]; then
    :
else
    service $service initdb &> /dev/null
    service $service start || exit $?
fi

#postgresql://user:mdp@127.0.0.1/base
dbuser=`  awk -F= '/^sqlalchemy_url=/ {gsub("\\\\w+://",                  "", $2); gsub(":.*", "", $2); print $2}' /etc/vigilo/models/settings.ini`
dbpasswd=`awk -F= '/^sqlalchemy_url=/ {gsub("\\\\w+://\\\\w+:",           "", $2); gsub("@.*", "", $2); print $2}' /etc/vigilo/models/settings.ini`
dbname=`  awk -F= '/^sqlalchemy_url=/ {gsub("\\\\w+://\\\\w+:\\\\w+@.*/", "", $2);                      print $2}' /etc/vigilo/models/settings.ini`

[ -n "$dbname" -a -n "$dbuser" -a -n "$dbpasswd" ]
echo "Base configurée: $dbname. Utilisateur configuré: $dbuser."
sleep 5


# Autoriser les connexions de l'utilisateur Vigilo
if [ -f /var/lib/pgsql/data/pg_hba.conf ]; then
    if ! grep -qs vigilo /var/lib/pgsql/data/pg_hba.conf; then
        echo "Attention, l'utilisateur vigilo n'est pas autorisé à se connecter à la base de données. Je l'ajoute, mais il faudra vérifier les permissions dans /var/lib/pgsql/data/pg_hba.conf" | fmt
        sed -i -e "/^# TYPE\s\+DATABASE\s\+USER\s\+CIDR-ADDRESS\s\+METHOD\s*$/a host $dbname $dbuser ::1/128 md5" /var/lib/pgsql/data/pg_hba.conf
        sed -i -e "/^# TYPE\s\+DATABASE\s\+USER\s\+CIDR-ADDRESS\s\+METHOD\s*$/a host $dbname $dbuser 127.0.0.1/32 md5" /var/lib/pgsql/data/pg_hba.conf
        sed -i -e "/^# TYPE\s\+DATABASE\s\+USER\s\+CIDR-ADDRESS\s\+METHOD\s*$/a #Access to vigilo database" /var/lib/pgsql/data/pg_hba.conf
        service postgresql reload
    fi
fi


# Utilisateur
sudo -u postgres psql -A -t -c '\du' | grep -qs '^'$dbuser || \
    sudo -u postgres psql -c "CREATE ROLE $dbuser PASSWORD '$dbpasswd' NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;"

# Base de données
if ! sudo -u postgres psql -A -t -l | grep -qs '^'$dbname; then
    sudo -u postgres createdb $dbname --owner $dbuser --encoding UTF8 -T template0 || exit $?
    echo "Création des tables dans la base de données PostgreSQL"
    mkdir -p log
    vigilo-updatedb || exit $?
    echo "(Désactivé) Remplissage de la base de données PostgreSQL"
    #vigilo-models-demo example1
    rm -rf log
fi
