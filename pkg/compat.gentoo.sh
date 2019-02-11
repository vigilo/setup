# Copyright (C) 2012-2019 CS-SI
# License: GNU GPL v2 <http://www.gnu.org/licenses/gpl-2.0.html>

import_pkg_key() {
    return 1
}

check_pkg() {
    return 1
}

check_svc() {
    service=$1
    [ -f /etc/init.d/$service ]
    return $?
}

install_pkg() {
    echo "Impossible d'installer '""$@""' automatiquement."
    echo "Installez le(s) paquet(s) manuellement, puis appuyez sur Entrée pour continuer."
    read unused
    return 0
}

change_svc() {
    if [ "$2" = "on" ]; then
        value=add
    else
        value=del
    fi

    rc-update $value $1 default;;
}

service() {
    svc=$1
    shift
    cmd=`which service 2> /dev/null`
    if [ $? -eq 0 ]; then
        "$cmd" "$svc" "$@"
        return $?
    fi

    if [ -f "/etc/init.d/$svc" ]; then
        "/etc/init.d/$svc" "$@"
        return $?
    fi

    if [ -f "/etc/rc.d/$svc" ]; then
        "/etc/rc.d/$svc" "$@"
        return $?
    fi

    echo "Impossible d'effectuer l'action '$1' sur le service '$svc'."
    echo "Effectuez l'action manuellement, puis appuyez sur Entrée pour continuer."
    read unused
    return 0
}
