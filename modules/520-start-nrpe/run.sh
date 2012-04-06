#!/bin/sh
# Copyright (C) 2011-2012 CS-SI
# License: GNU GPL v2 <http://www.gnu.org/licenses/gpl-2.0.html>

chkconfig nrpe on
service nrpe status &> /dev/null
RET=$?
if [ "$RET" -eq "0" ]; then
    service nrpe restart
else
    service nrpe start
fi
