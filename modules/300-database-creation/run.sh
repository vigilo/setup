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


# Autoriser les connexions de l'utilisateur Vigilo
if grep -qs 'local \+all \+all \+ident \+sameuser' /var/lib/pgsql/data/pg_hba.conf; then
    if ! grep -qs vigilo /var/lib/pgsql/data/pg_hba.conf; then
        echo "Attention, l'utilisateur vigilo n'est pas autorisé à se connecter à la base de données. Je l'ajoute, mais il faudra vérifier les permissions dans /var/lib/pgsql/data/pg_hba.conf" | fmt
        sed -i -e '/^# TYPE\s\+DATABASE\s\+USER\s\+CIDR-ADDRESS\s\+METHOD\s*$/a host vigilo vigilo 127.0.0.1/32 md5' /var/lib/pgsql/data/pg_hba.conf
    fi
fi


# Utilisateur
psql -U postgres -A -t -c '\du' | grep -qs '^'$dbuser || \
    psql -U postgres -c "CREATE ROLE $dbuser PASSWORD '$dbpasswd' NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;"

# Base de données
if ! psql -U postgres -A -t -l | grep -qs '^'$dbname; then
    createdb -U postgres $dbname --owner $dbuser --encoding UTF8
    echo "Création des tables dans la base de données PostgreSQL"
    mkdir -p log
    vigilo-models-init-db
    echo "(Désactivé) Remplissage de la base de données PostgreSQL"
    #vigilo-models-demo example1
    rm -rf log
fi

