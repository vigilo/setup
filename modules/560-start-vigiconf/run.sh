#!/bin/sh

# Import de la couche de compatibilité.
. "`dirname $0`/../compat.sh"

echo "Lancement de vigiconf"
vigiconf deploy --force
