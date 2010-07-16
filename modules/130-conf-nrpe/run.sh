#/bin/sh

echo "Configuration de NRPE"
if [ ! -f /etc/nagios/nrpe_local.cfg ]; then
    cp nrpe_local.cfg /etc/nagios/
    echo "include=/etc/nagios/nrpe_local.cfg" >> /etc/nagios/nrpe.cfg
    sed -i -e 's/^dont_blame_nrpe=0/dont_blame_nrpe=1/' /etc/nagios/nrpe.cfg 
fi

