#!/usr/bin/env bash

# If return err, shell will exit
set -e

program=$0
usage="$program [-n <name> | -P <server_port>] [-h]"

DIR=$(cd `dirname $program`; pwd)

. $DIR/ss_manager_lib.sh

if [ ! -f "$main_supervisor_config_file" ]; then
    echo "$main_supervisor_config_file does not exist."
    exit 1
fi

#mkdir -p $ss_configs_dir
mkdir -p $supervisor_configs_dir
touch $users

function help() {
    echo "usage: $usage"
    echo -e "\t-n option is used to set a name to the supervisor program."
    echo -e "\t-P option is used to set a server port."
    echo -e "\t\tNote: -n/-P are at least one."
    echo -e "\t-h will display this messages."
}

# main
while getopts "n:P:h" arg
do
    case "$arg" in
        n) # name
            name=ss_$OPTARG
            ;;
        P) # server_port
            server_port=$OPTARG
            is_port_number $server_port
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

if [ -z "$name" ] && [ -z "$server_port" ]; then
    echo "At least one of -n and -P option."
    help
    exit 1
fi

if [ -z "$name" ]; then
    name=ss_$server_port
fi
if [ -z "$server_port" ]; then
    server_port=`container_port $name`
fi

echo "$name program will be remove."
sed -r "/\-P +$server_port/d" $users -i
rm -f $supervisor_configs_dir/$name.ini*
if [ -n "$server_port" ] && [ "$name" != "ss_$server_port" ]; then
    rm -f $supervisor_configs_dir/ss_$server_port.ini*
fi
supervisorctl -c $main_supervisor_config_file update
