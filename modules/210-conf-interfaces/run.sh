#!/bin/sh

echo "Configuration de VigiBoard"
ln -sf /etc/vigilo/vigiboard/vigiboard.conf /etc/httpd/conf/webapps.d/vigiboard.conf

echo "Configuration de VigiGraph"
ln -sf /etc/vigilo/vigigraph/vigigraph.conf /etc/httpd/conf/webapps.d/vigigraph.conf

echo "Configuration de VigiMap"
ln -sf /etc/vigilo/vigimap/vigimap.conf /etc/httpd/conf/webapps.d/vigimap.conf

