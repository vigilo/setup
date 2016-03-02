# Copyright (C) 2011-2016 CS-SI
# License: GNU GPL v2 <http://www.gnu.org/licenses/gpl-2.0.html>

# Import de la couche de compatibilité.
. "`dirname $0`/../compat.sh"

[ -f /etc/init.d/rabbitmq-server ] || exit 0

echo "Création des comptes sur le bus"
sleep 5
rabbitmqctl add_user vigilo-admin vigilo-admin || :
rabbitmqctl set_permissions vigilo-admin '.*' '.*' '.*'

CONNECTORS="connector-nagios connector-metro correlator"

for connector in $CONNECTORS; do
    settings_files=`fgrep -l '[bus]' /etc/vigilo/$connector/*.ini 2>/dev/null`
    create_bus_user $connector $settings_files
done
