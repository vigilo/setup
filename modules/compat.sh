#!/bin/sh

import_pkg_key() {
    case "$DISTRO" in
        mandriva|redhat)
            keyid=`echo $1 | tr '[:upper:]' '[:lower:]'`
            rpm -q $keyid >/dev/null 2>&1 || rpm --import $2
            res=$?
            ;;
        debian)
            keyid=`echo $1 | tr '[:lower:]' '[:upper:]'`
            $(apt-key list 2>/dev/null | grep -e '^pub[^/]\+'"$keyid" >/dev/null) || apt-key add $2 >/dev/null 2>&1
            res=$?
            ;;
        gentoo)
            # @TODO:
            return 1
            ;;
        *)
            # @FIXME: par défaut, on suppose que la clé n'a pas été importée.
            return 1
            ;;
    esac
}

check_pkg() {
    case "$DISTRO" in
        mandriva|redhat)
            cmd="rpm -q"
            ;;
        debian)
            cmd="dpkg -l"
            ;;
        gentoo)
            # @TODO:
            return 1
            ;;
        *)
            # @FIXME: par défaut, on suppose que le paquet n'est pas installé.
            return 1
            ;;
    esac

    $cmd $1 >/dev/null 2>&1
}

install_pkg() {
    case "$DISTRO" in
        mandriva)
            cmd="urpmi ${AUTO_INSTALL:+"--auto"} ${NO_PKG_CHECK:+"--no-verify-rpm"}"
            ;;
        redhat)
            cmd="yum ${AUTO_INSTALL:+"-y"} ${NO_PKG_CHECK:+"--nogpgcheck"} install"
            ;;
        debian)
            cmd="apt-get install --no-install-recommends ${AUTO_INSTALL:+"-y"} ${NO_PKG_CHECK:+"--allow-unauthenticated"}"
            ;;
        *)
            echo "Impossible d'installer '""$@""' automatiquement."
            echo "Installez le(s) paquet(s) manuellement, puis appuyez sur Entrée pour continuer."
            read unused
            return 0
            ;;
    esac
    $cmd "$@"
}

change_svc() {
    if [ "$2" = "on" ]; then
        case "$DISTRO" in
            redhat|mandriva)
                value=on;;
            debian)
                value=enable;;
            gentoo)
                value=add;;
        esac
    else
        case "$DISTRO" in
            redhat|mandriva)
                value=off;;
            debian)
                value=disable;;
            gentoo)
                value=del;;
        esac
    fi

    case "$DISTRO" in
        redhat|mandriva)
            chkconfig $1 $value;;
        debian)
            update-rc.d $1 $value;;
        gentoo)
            rc-update $value $1 default;;
        *)
            echo "Impossible d'activer le service $1 automatiquement."
            echo "Activez le service manuellement, puis appuyez sur Entrée pour continuer."
            echo "L'activation d'un service se fait généralement via la commande chkconfig ou update-rc.d."
            read unused
            return 0
            ;;
    esac
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
