#!/bin/sh

[ -f /etc/init.d/httpd ] || exit 0

chkconfig httpd on
service httpd configtest && service httpd restart
