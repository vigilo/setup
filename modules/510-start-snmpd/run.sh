#!/bin/sh

chkconfig snmpd on
service snmpd status &> /dev/null || service snmpd start
