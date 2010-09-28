#!/bin/sh

urpmi   --auto $1 $2 \
        nagios-check_nrpe \
        nagios-check_ntp \
        net-snmp \
        patch \
        nrpe \
        vigilo-nagios-plugins-cpu \
        vigilo-nagios-plugins-raid

