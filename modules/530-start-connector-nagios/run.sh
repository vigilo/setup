#!/bin/sh

service vigilo-connector-nagios start

echo -n "Attente de la création des noeuds pubsub..."
sleep 5
echo
