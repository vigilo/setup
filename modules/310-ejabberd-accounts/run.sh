#!/bin/sh

echo "Création des comptes sur le bus XMPP"
service ejabberd status &> /dev/null  || service ejabberd start
sleep 2
for connector in connector-nagios connector-metro connector-vigiboard connector-diode correlator; do
    password=`awk '/^password/ {print $3}' /etc/vigilo/$connector/settings.ini`
    # case where a server dont have all the connector.
    [ -z "$password" ] && password=$connector
    su ejabberd -c "ejabberdctl --node ejabberd@localhost register '$connector' localhost '$password'" || :
done

echo -n "Attente prise en compte création des comptes"
i=0
while [ $i -lt 15 ]; do
    sleep 1
    let "i += 1"
    echo -n "."
done
echo ""

