#!/bin/bash

# Configure VigiConf to have everything monitored by the local host

sed -i -e "s,supserver.example.com,localhost,g" \
    /etc/vigilo-vigiconf/conf.d/general/appgroups-servers.py

# Disable DNS generation

sed -r -i -e "s|(\s*'dns1'\s*:\s*)\['dns1'\],|\1[],|g" \
    /etc/vigilo-vigiconf/conf.d/general/apps.py
