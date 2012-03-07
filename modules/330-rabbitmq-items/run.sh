#!/bin/sh

echo "Création des exchanges sur le bus AMQP"

vigilo-bus-config -u vigilo-admin -p vigilo-admin read-config exchanges.ini
