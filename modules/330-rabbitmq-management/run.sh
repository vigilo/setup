#!/bin/sh

echo "Activation de l'interface de gestion"
rabbitmq-plugins enable rabbitmq_management
/etc/init.d/rabbitmq-server restart
