#!/bin/sh
# Copyright (C) 2011-2012 CS-SI
# License: GNU GPL v2 <http://www.gnu.org/licenses/gpl-2.0.html>

[ -f /etc/init.d/httpd ] || exit 0

chkconfig httpd on
service httpd configtest && service httpd restart
