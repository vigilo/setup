#!/bin/sh

service nrpe status &> /dev/null || service snmpd start
