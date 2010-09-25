#!bin/sh

echo "Création de la base de données PostgreSQL"
chkconfig postgresql on
pgrep postmaster > /dev/null || service postgresql start

dbname=`awk -F= '/^sqlalchemy_url/ {gsub(".*/","",$2); print $2}' /etc/vigilo/models/settings.ini`
dbuser=`awk -F= '/^sqlalchemy_url/ {gsub("\\\\w+://","",$2); gsub(":.*","",$2); print $2}' /etc/vigilo/models/settings.ini`
dbpasswd=`awk -F= '/^sqlalchemy_url/ {gsub("\\\\w+://vigilo:","",$2); gsub("@.*","",$2); print $2}' /etc/vigilo/models/settings.ini`
[ -n "$dbname" -a -n "$dbuser" -a -n "$dbpasswd" ]
echo "Base configurée: $dbname. Utilisateur configuré: $dbuser."
sleep 5

# Utilisateur
psql -U postgres -A -t -c '\du' | grep -qs '^'$dbuser || \
    psql -U postgres -c "CREATE ROLE $dbuser PASSWORD '$dbpasswd' NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;"

# Base de données
if ! psql -U postgres -A -t -l | grep -qs '^'$dbname; then
    createdb -U postgres $dbname --owner $dbuser --encoding UTF8
    echo "Création des tables dans la base de données PostgreSQL"
    mkdir -p log
    vigilo-models-init-db
    echo "Remplissage de la base de données PostgreSQL"
    vigilo-models-demo example1
    rm -rf log
fi

