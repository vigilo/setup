# Copyright (C) 2017-2019 CS-SI
# License: GNU GPL v2 <http://www.gnu.org/licenses/gpl-2.0.html>

create_bus_user() {
    connector=$1
    shift
    settings_files="$@"

    if [ -z "$settings_files" ]; then
        rabbitmqctl add_user "$connector" "$connector" || :
        rabbitmqctl set_permissions "$connector" '.*' '.*' '.*'
    else
        for settings_file in $settings_files; do
            username=`vigilo-config -s bus -g user "$settings_file" 2>/dev/null || :`
            password=`vigilo-config -s bus -g password "$settings_file" 2>/dev/null || :`
            rabbitmqctl add_user "$username" "$password" || :
            rabbitmqctl set_permissions "$username" '.*' '.*' '.*'
        done
    fi
}

start_service() {
    change_svc $1 on
    service $1 status &> /dev/null
    if [ $? -eq 0 ]; then
        service $1 restart || exit $?
    else
        service $1 start || exit $?
    fi
}
