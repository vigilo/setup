#!/bin/sh

echo "Configuration de connector-metro"
ln -sfT /etc/vigilo/vigiconf/prod/connector-metro.conf.py /etc/vigilo/connector-metro/connector-metro.conf.py || :
