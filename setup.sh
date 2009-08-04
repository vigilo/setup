#!/bin/sh

CONF=/etc/vigilo-setup/setup.conf

if [ -f $CONF ]; then
    . $CONF
else
    echo "Can't find $CONF. Abort"
    exit 1
fi

# All those scripts must be idempotent
for script in $SETUP_SCRIPTS/*.{sh,py} 2>/dev/null; do
	if [ -x $script ]; then
		bash $script
        RETVAL=$?
        if [ $RETVAL != 0 ]; then
            echo "Script $script failed !"
            exit $RETVAL
        fi
	fi
done
