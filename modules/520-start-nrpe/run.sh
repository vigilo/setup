#/bin/sh

chkconfig nrpe on
service nrpe status &> /dev/null
RET=$?
if [ "$RET" -eq "0" ]; then
    service nrpe restart
else
    service nrpe start
fi
