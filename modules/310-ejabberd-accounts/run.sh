#!/bin/sh

[ -f /etc/init.d/ejabberd ] || exit 0

echo "Création des comptes sur le bus XMPP"
chkconfig ejabberd on
service ejabberd status &> /dev/null  || service ejabberd start || exit $?
sleep 5
ejabberdctl register vigilo-admin localhost vigilo-admin || :

# Connecteurs de la version communautaire (configuration dans settings.ini)
for connector in connector-diode connector-nagios connector-metro connector-syncevents connector-script correlator; do
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
done

# Connecteurs de la version entreprise (configuration dans settings-enterprise.ini)
for connector in vigiconf; do
    settings_file=/etc/vigilo/$connector/settings-enterprise.ini
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
done

# Connecteur vigiconf-hls.
settings_file=/etc/vigilo/vigiconf/settings-hls.ini
if [ -f "$settings_file" ] ; then
    jid=`vigilo-config -s bus -g jid $settings_file 2>/dev/null || :`
    username=`echo $jid | cut -d@ -f1`
    password=`vigilo-config -s bus -g password $settings_file`
else
    # Si le serveur n'a pas tous les connecteurs installés
    username=vigiconf-hls
    password=vigiconf-hls
fi
ejabberdctl register $username localhost $password || :

