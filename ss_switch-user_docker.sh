#!/usr/bin/env bash

# If return err, shell will exit
set -e

program=$0
usage="$program [-n <name> | -P <server_port>] [-D | -E | -R] [-h]"

DIR=$(cd `dirname $program`; pwd)

. $DIR/ss_manager_lib.sh

if [ ! -f "$main_supervisor_config_file" ]; then
    echo "$main_supervisor_config_file does not exist."
    exit 1
fi

function help() {
    echo "usage: $usage"
    echo -e "\t-n option is used to set a name to the supervisor program."
    echo -e "\t-P option is used to set a server port."
    echo -e "\t\tNote: -n/-P are at least one."
    echo -e "\t-D will disable specified user."
    echo -e "\t-E will enable specified user."
    echo -e "\t-R will restart user program, when there is a problem with the user program."
    echo -e "\t\tNote: -D/-E/-R can only be one."
    echo -e "\t-h will display this messages."
}

# main
while getopts "n:P:hDER" arg
do
    case "$arg" in
        n) # name
            name=ss_$OPTARG
            ;;
        P) # server_port
            server_port=$OPTARG
            is_port_number $server_port
            ;;
        D) # disable user
            action=stop
            ;;
        E) # enable user
            action=start
            ;;
        R) # restart user program
            action=restart
            ;;
        h) # help
            help
            exit 0
            ;;
        *) # others are unknow
            echo "unknow argument"
            help
            exit 1
            ;;
    esac
done

if [ -z "$name" ] && [ -z "$server_port" ] || [ -z "$action" ]; then
    echo "Arguments are incomplete."
    help
    exit 1
fi

if [ -z "$name" ]; then
    name=ss_$server_port
fi

echo "$name program will be $action."
config=$supervisor_configs_dir/$name.ini
if [ "$action" == "stop" ]; then
    mv $config $config~
    supervisorctl -c $main_supervisor_config_file update
else
    if [ -f "$config" ]; then
        find $config* | grep -v -E "$config$" | xargs rm -f
        supervisorctl -c $main_supervisor_config_file $action $name
    else
        mv $config~ $config
        supervisorctl -c $main_supervisor_config_file update
    fi
fi
unset config
