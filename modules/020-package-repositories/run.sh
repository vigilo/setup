#!/bin/sh

if [ -z "$VIGILO_REPO" ]; then
    echo "La variable VIGILO_REPO doit être déclarée"
    exit 1
fi


if [ -z "$VIGILO_DEPS_REPO" ]; then
    echo "La variable VIGILO_DEPS_REPO doit être déclarée"
    exit 1
fi

if [ "$DISTRO" == "mandriva" ]; then
    urpmq --list-media | grep -qs vigilo || urpmi.addmedia vigilo $VIGILO_REPO
    urpmq --list-media | grep -qs vigilo-deps || urpmi.addmedia vigilo-deps $VIGILO_DEPS_REPO
elif [ "$DISTRO" == "redhat" ]; then
    [ -f /etc/yum.repos.d/vigilo.repo ] || \
        cat > /etc/yum.repos.d/vigilo.repo << EOF
[vigilo]
name=Vigilo
baseurl=$VIGILO_REPO
enabled=1
gpgcheck=1
metadata_expire=1d

[vigilo-deps]
name=Vigilo dependencies
baseurl=$VIGILO_DEPS_REPO
enabled=1
gpgcheck=1
metadata_expire=1d
EOF
    [ -f /etc/yum.repos.d/epel.repo ] || yum -y --nogpgcheck install epel-release
fi

[ -f /etc/yum/pluginconf.d/fastestmirror.conf ] && \
    sed -i -e 's/^enabled=1$/enabled=0/' /etc/yum/pluginconf.d/fastestmirror.conf

