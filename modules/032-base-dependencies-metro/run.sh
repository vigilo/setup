#!/bin/sh

urpmi   $RPM_SIGNATURE_CHECK $AUTO_INSTALL \
        nagios-check_nrpe \
        nagios-check_ntp \
        net-snmp \
        patch \
        nrpe \
        vigilo-nagios-plugins-cpu \
        vigilo-nagios-plugins-raid

