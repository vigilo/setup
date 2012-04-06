#!/bin/sh
# Copyright (C) 2011-2012 CS-SI
# License: GNU GPL v2 <http://www.gnu.org/licenses/gpl-2.0.html>

echo "Création des exchanges sur le bus AMQP"

vigilo-bus-config -u vigilo-admin -p vigilo-admin read-config exchanges.ini
