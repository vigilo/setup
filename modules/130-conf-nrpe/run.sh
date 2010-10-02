#/bin/sh

echo "Configuration de NRPE"
sed -i -e 's/^dont_blame_nrpe=0/dont_blame_nrpe=1/' /etc/nagios/nrpe.cfg 

if [ "$DISTRO" == "redhat" ]; then
    cp -p nrpe_local.cfg /etc/nrpe.d/
else
    if [ ! -f /etc/nagios/nrpe_local.cfg ]; then
        cp nrpe_local.cfg /etc/nagios/
        echo "include=/etc/nagios/nrpe_local.cfg" >> /etc/nagios/nrpe.cfg
    fi
fi
