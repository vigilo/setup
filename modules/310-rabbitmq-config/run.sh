# Copyright (C) 2011-2020 CS GROUP - France
# License: GNU GPL v2 <http://www.gnu.org/licenses/gpl-2.0.html>

# Import de la couche de compatibilité.
. "`dirname $0`/../compat.sh"

# Management
echo "Activation de l'interface de gestion"

# Sous RHEL/CentOS, rabbitmq-plugins se trouve désormais
# dans un dossier non standard (cf. #1274).
old_PATH=$PATH
PATH=$PATH:/usr/lib/rabbitmq/bin/
export PATH
rabbitmq-plugins enable rabbitmq_management
PATH=$old_PATH
export PATH

echo "Génération du certificat SSL"
service=rabbitmq
sslcert=/etc/pki/tls/certs/$service.pem
sslkey=/etc/pki/tls/private/$service.pem
if [ ! -f $sslcert ]; then
    echo "Generating SSL certificate for $service..."
    HOSTNAME=$(hostname -s 2>/dev/null || echo "localhost")
    DOMAINNAME=$(hostname -d 2>/dev/null || echo "localdomain")
    openssl genrsa -out $sslkey 2048 > /dev/null 2>&1
    openssl req -new -x509 -days 3650 -nodes -out $sslcert \
                -key $sslkey > /dev/null 2>&1 <<+++
.
.
.
.
$service
$HOSTNAME.$DOMAINNAME
root@$HOSTNAME.$DOMAINNAME
+++
chown rabbitmq:rabbitmq $sslcert $sslkey
chmod 600 $sslkey
fi

sed -i -e "s/__HOSTNAME__/$HOSTNAME/g" rabbitmq.config
# Fichier de config
cp -pu rabbitmq.config /etc/rabbitmq/
chown rabbitmq:rabbitmq /etc/rabbitmq/rabbitmq.config
chown rabbitmq:rabbitmq /etc/rabbitmq/enabled_plugins

# démarrage
service=rabbitmq-server
change_svc $service on
service $service status &> /dev/null
RET=$?
if [ "$RET" == "0" ]; then
    service $service restart || exit $?
else
    service $service start || exit $?
fi
