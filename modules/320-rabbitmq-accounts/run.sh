# Copyright (C) 2011-2021 CS GROUP - France
# License: GNU GPL v2 <http://www.gnu.org/licenses/gpl-2.0.html>

# Import de la couche de compatibilité.
. "`dirname $0`/../compat.sh"

# Fonctions de base
. "`dirname $0`/../common.sh"

check_svc "rabbitmq-server" || exit 0

echo "Création des comptes sur le bus"
sleep 5
create_bus_user vigilo-admin

CONNECTORS="connector-nagios connector-metro correlator"

for connector in $CONNECTORS; do
    settings_files=`fgrep -l '[bus]' /etc/vigilo/$connector/*.ini 2>/dev/null`
    create_bus_user $connector $settings_files
done
