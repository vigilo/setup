#!/bin/sh

[ -f /etc/init.d/ejabberd ] || exit 0

echo "Création des comptes sur le bus XMPP"
chkconfig ejabberd on
service ejabberd status &> /dev/null  || service ejabberd start || exit $?
sleep 5
ejabberdctl register vigilo-admin localhost vigilo-admin || :
for connector in connector-diode connector-nagios connector-metro connector-syncevents connector-script vigiconf correlator; do
    settings_file=/etc/vigilo/$connector/settings.ini
    if [ -f "$settings_file" ] ; then
        jid=`vigilo-config -s bus -g jid $settings_file 2>/dev/null || :`
        username=`echo $jid | cut -d@ -f1`
        password=`vigilo-config -s bus -g password $settings_file`
    else
        # Si le serveur n'a pas tous les connecteurs installés
        username=$connector
        password=$connector
    fi
    ejabberdctl register $username localhost $password || :
    echo -n "."
done

echo "."
