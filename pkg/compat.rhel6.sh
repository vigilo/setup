# Copyright (C) 2012-2020 CS GROUP - France
# License: GNU GPL v2 <http://www.gnu.org/licenses/gpl-2.0.html>

import_pkg_key() {
    keyid=`echo $1 | tr '[:upper:]' '[:lower:]'`
    rpm -q $keyid >/dev/null 2>&1 || rpm --import $2
    res=$?
}

check_pkg() {
    cmd="rpm -q"
    $cmd $1 >/dev/null 2>&1
}

check_svc() {
    service=$1
    [ -f /etc/init.d/$service ]
    return $?
}

install_pkg() {
    cmd="yum ${AUTO_INSTALL:+"-y"} ${NO_PKG_CHECK:+"--nogpgcheck"} install"
    $cmd "$@"
}

change_svc() {
    if [ "$2" = "on" ]; then
        value=on
    else
        value=off
    fi

    chkconfig $1 $value
}

service() {
    svc=$1
    shift
    cmd=`which service 2> /dev/null`
    if [ $? -eq 0 ]; then
        "$cmd" "$svc" "$@"
        return $?
    fi

    echo "Impossible d'effectuer l'action '$1' sur le service '$svc'."
    echo "Effectuez l'action manuellement, puis appuyez sur Entrée pour continuer."
    read unused
    return 0
}
