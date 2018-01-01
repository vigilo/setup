# Copyright (C) 2012-2018 CS-SI
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

    [ -f /usr/lib/systemd/system/${service}.service ]
    return $?
}

install_pkg() {
    cmd="yum ${AUTO_INSTALL:+"-y"} ${NO_PKG_CHECK:+"--nogpgcheck"} install"
    $cmd "$@"
}

change_svc() {
    if [ "$2" = "on" ]; then
        value=enable
    else
        value=disable
    fi

    systemctl $value ${1}
}

service() {
    systemctl $2 $1
    return $?
}
