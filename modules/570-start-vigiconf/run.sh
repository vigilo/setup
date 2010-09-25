#!/bin/sh

echo "Lancement de vigiconf"
vigiconf deploy

# start vigilo-connector-metro if necessary (hook for first attempt of vigiconf deploy...)
/etc/init.d/vigilo-connector-metro status &> /dev/null || /etc/init.d/vigilo-connector-metro start
