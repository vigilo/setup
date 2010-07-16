#!/bin/sh

rpm -q gpg-pubkey-c8f06b7e-4bd5664e >/dev/null 2>&1 || rpm --import vigilo-gpg.txt
