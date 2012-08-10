#!/bin/sh
# Copyright (C) 2011-2012 CS-SI
# License: GNU GPL v2 <http://www.gnu.org/licenses/gpl-2.0.html>

[ -f /etc/init.d/httpd ] || exit 0

service=httpd
chkconfig $service on
service $service status &> /dev/null
RET=$?
if [ "$RET" == "0" ]; then
    service httpd configtest && \
        service $service restart || exit $?
else
    service httpd configtest && \
        service $service start || exit $?
fi
