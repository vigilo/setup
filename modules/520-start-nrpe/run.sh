# Copyright (C) 2011-2020 CS GROUP – France
# License: GNU GPL v2 <http://www.gnu.org/licenses/gpl-2.0.html>

# Import de la couche de compatibilité.
. "`dirname $0`/../compat.sh"
. "`dirname $0`/../common.sh"

service=nrpe
start_service $service
