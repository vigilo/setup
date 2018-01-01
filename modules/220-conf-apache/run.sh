# Copyright (C) 2006-2018 CS-SI
# License: GNU GPL v2 <http://www.gnu.org/licenses/gpl-2.0.html>

# Import de la couche de compatibilité.
. "`dirname $0`/../compat.sh"

echo "Configuration du serveurs web Apache"
if [ "$DISTRO" == "debian" ]; then
    a2enmod headers
fi

# On ne redémarre pas Apache, le script
# 550-restart-apache le fera pour nous.

