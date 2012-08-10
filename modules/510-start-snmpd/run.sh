#!/bin/sh

service=snmpd
chkconfig $service on
service $service status &> /dev/null
RET=$?
if [ "$RET" == "0" ]; then
    service $service restart || exit $?
else
    service $service start || exit $?
fi
