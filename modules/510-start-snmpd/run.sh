#!/bin/sh

service snmpd status &> /dev/null || service snmpd start
