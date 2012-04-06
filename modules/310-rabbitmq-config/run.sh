#!/bin/sh
# Copyright (C) 2011-2012 CS-SI
# License: GNU GPL v2 <http://www.gnu.org/licenses/gpl-2.0.html>

# Management
echo "Activation de l'interface de gestion"
rabbitmq-plugins enable rabbitmq_management

# SSL
sslcert=/etc/pki/tls/certs/rabbitmq.pem
sslkey=/etc/pki/tls/private/rabbitmq.pem
if [ ! -f $sslcert ]; then
    echo "Generating SSL certificate for RabbitMQ..."
    HOSTNAME=$(hostname -s 2>/dev/null || echo "localhost")
    DOMAINNAME=$(hostname -d 2>/dev/null || echo "localdomain")
    openssl genrsa -out $sslkey 2048 > /dev/null 2>&1
    openssl req -new -x509 -days 3650 -nodes -out $sslcert \
                -key $sslkey > /dev/null 2>&1 <<+++
.
.
.
$DOMAINNAME
$HOSTNAME
rabbitmq
root@$HOSTNAME.$DOMAINNAME
+++
chown rabbitmq:rabbitmq $sslcert $sslkey
chmod 600 $sslkey
fi

# Fichier de config
cp -pu rabbitmq.config /etc/rabbitmq/

# Redémarrage
/etc/init.d/rabbitmq-server restart
