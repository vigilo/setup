#!/bin/sh

if [ -z "$VIGILO_REPO" ]; then
    echo "La variable VIGILO_REPO doit être déclarée"
    exit 1
fi
urpmq --list-media | grep -qs vigilo || urpmi.addmedia vigilo $VIGILO_REPO


if [ -z "$VIGILO_DEPS_REPO" ]; then
    echo "La variable VIGILO_DEPS_REPO doit être déclarée"
    exit 1
fi
urpmq --list-media | grep -qs vigilo-deps || urpmi.addmedia vigilo-deps $VIGILO_DEPS_REPO
