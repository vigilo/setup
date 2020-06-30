# Copyright (C) 2011-2020 CS GROUP - France
# License: GNU GPL v2 <http://www.gnu.org/licenses/gpl-2.0.html>

# Import de la couche de compatibilité.
. "`dirname $0`/../compat.sh"

echo "Création des exchanges sur le bus AMQP"

vigilo-bus-config -u vigilo-admin -p vigilo-admin read-config exchanges.ini
