# Copyright (C) 2018-2020 CS-SI
# License: GNU GPL v2 <http://www.gnu.org/licenses/gpl-2.0.html>

# Import de la couche de compatibilité.
. "`dirname $0`/../compat.sh"

echo "Vérification de la configuration de SELinux"

status=`getenforce 2> /dev/null`
if [ "$status" = "Enforcing" ]; then
    echo "Vigilo ne peut pas s'exécuter lorsque SELinux est activé." >&2
    echo "Veuillez désactiver SELinux ou le configurer en mode 'Permissive' " >&2
    echo "avant de continuer." >&2
    exit 1
fi
