#!/bin/sh

echo "Installation des paquets Vigilo"
urpmi   vigilo-collector \
        vigilo-collector-enterprise \
        vigilo-connector-nagios \
        vigilo-connector-metro \
        vigilo-connector-vigiboard \
        vigilo-connector-diode \
        vigilo-correlator \
        vigilo-perfdata2vigilo \
        vigilo-vigiboard \
        vigilo-vigiconf \
        vigilo-vigiconf-local \
        vigilo-vigimap \
        vigilo-vigigraph \
        vigilo-vigirrd \
        vigilo-vigirrd-vigiconf
