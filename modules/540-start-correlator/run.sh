# Copyright (C) 2011-2018 CS-SI
# License: GNU GPL v2 <http://www.gnu.org/licenses/gpl-2.0.html>

# Import de la couche de compatibilité.
. "`dirname $0`/../compat.sh"
. "`dirname $0`/../common.sh"

service=vigilo-correlator
start_service $service
if [ "$DISTRO" = "redhat" ] && [ $((0$DIST_VER + 0)) -ge 7 ]; then
    # Sur RHEL/CentOS 7+, on doit aussi démarrer une instance du template.
    start_service $service@1
fi
