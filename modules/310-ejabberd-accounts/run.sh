#!/bin/sh

[ -f /etc/init.d/ejabberd ] || exit 0

echo "Création des comptes sur le bus XMPP"
chkconfig ejabberd on
service ejabberd status &> /dev/null  || service ejabberd start || exit $?
sleep 5
for connector in connector-nagios connector-metro connector-diode correlator; do
    [ -f /etc/vigilo/$connector/settings.ini ] || continue
    password=`awk '/^password/ {print $3}' /etc/vigilo/$connector/settings.ini`
    # case where a server dont have all the connector.
    [ -z "$password" ] && password=$connector
    ejabberdctl register $connector localhost $password || :
done

echo -n "Attente de la création effective des comptes"
i=0
while [ $i -lt 15 ]; do
    sleep 1
    let "i += 1"
    echo -n "."
done
echo ""

