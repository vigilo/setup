#!/bin/sh

echo "Création des comptes sur le bus XMPP"
service ejabberd status &> /dev/null  || service ejabberd start
sleep 2
for connector in connector-nagios connector-metro connector-vigiboard connector-diode correlator; do
    password=`awk '/^password/ {print $3}' /etc/vigilo/$connector/settings.ini`
    su ejabberd -c 'ejabberdctl --node ejabberd@localhost register '$connector' localhost '$password || :
done

