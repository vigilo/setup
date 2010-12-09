#!/bin/sh

[ -f /etc/init.d/ejabberd ] || exit 0

echo "Création des comptes sur le bus XMPP"
chkconfig ejabberd on
service ejabberd status &> /dev/null  || service ejabberd start || exit $?
sleep 5
for connector in connector-nagios connector-metro connector-diode correlator setup; do
    if [ -f /etc/vigilo/$connector/settings.ini ] ; then
        password=`awk '/^password/ {print $3}' /etc/vigilo/$connector/settings.ini`
    fi
    # in case a server does not host all the connectors.
    [ -z "$password" ] && password=$connector
    ejabberdctl register $connector localhost $password || :
    echo -n "."
done

ejabberdctl register vigilo-admin localhost vigilo-admin
echo "."
