# Copyright (C) 2012-2018 CS-SI
# License: GNU GPL v2 <http://www.gnu.org/licenses/gpl-2.0.html>

import_pkg_key() {
    keyid=`echo $1 | tr '[:lower:]' '[:upper:]'`
    $(apt-key list 2>/dev/null | grep -e '^pub[^/]\+'"$keyid" >/dev/null) || apt-key add $2 >/dev/null 2>&1
    res=$?
}

check_pkg() {
    cmd="dpkg -l"
    $cmd $1 >/dev/null 2>&1
}

check_svc() {
    service=$1
    [ -f /etc/init.d/$service ]
    return $?
}

install_pkg() {
    cmd="apt-get install --no-install-recommends ${AUTO_INSTALL:+"-y"} ${NO_PKG_CHECK:+"--allow-unauthenticated"}"
    $cmd "$@"
}

change_svc() {
    if [ "$2" = "on" ]; then
        value=enable
    else
        value=disable
    fi

    update-rc.d $1 $value;;
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
