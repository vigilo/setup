#!/bin/sh
# Copyright (C) 2011-2012 CS-SI
# License: GNU GPL v2 <http://www.gnu.org/licenses/gpl-2.0.html>

function creation_BUS_user {
    connector=$1
    shift
    settings_files="$@"

    if [ -z "$settings_files" ]; then
        rabbitmqctl add_user $connector $connector || :
        rabbitmqctl set_permissions $connector '.*' '.*' '.*'
    else
        for settings_file in $settings_files; do
            username=`vigilo-config -s bus -g user $settings_file 2>/dev/null || :`
            password=`vigilo-config -s bus -g password $settings_file 2>/dev/null || :`
            rabbitmqctl add_user $username $password || :
            rabbitmqctl set_permissions $username '.*' '.*' '.*'
        done
    fi
}

[ -f /etc/init.d/rabbitmq-server ] || exit 0

echo "Création des comptes sur le bus"
sleep 5
rabbitmqctl add_user vigilo-admin vigilo-admin || :
rabbitmqctl set_permissions vigilo-admin '.*' '.*' '.*'

CONNECTORS="connector-nagios connector-metro correlator"

for connector in $CONNECTORS; do
    settings_files=`fgrep -l '[bus]' /etc/vigilo/$connector/*.ini 2>/dev/null`
    creation_BUS_user $connector $settings_files
done
