#!/usr/bin/env bash

# If return err, shell will exit
set -e

program=$0
usage="$program [-n <name>] -P <server_port> -p <password> [-m <method>] [-t <timeout>] [-h] [-T]"

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
    echo -e "\t-n option is used to assign a name to the supervisor program."
    echo -e "\t\tOptional, default is server port."
    echo -e "\t-P option is used to assign a server port."
    echo -e "\t\tNote: -P is upper case."
    echo -e "\t-p option is used to set a password."
    echo -e "\t\tNote: -p is lower case."
    echo -e "\t-m option is used to set encryption algorithm."
    echo -e "\t\tOptional, default is $method."
    echo -e "\t-t option is used to set timeout."
    echo -e "\t\tOptional, default is 300."
    echo -e "\t-h option will show this message."
    echo -e "\t-T option is to set test."
}

# main
while getopts "n:P:p:m:t:hT" arg
do
    case "$arg" in
        n) # name
            name=ss_$OPTARG
            ;;
        P) # server_port
            server_port=$OPTARG
            is_port_number $server_port
            ;;
        p) # password
            password=$OPTARG
            ;;
        m) # method
            method=$OPTARG
            method_support $method
            ;;
        t) # timeout
            timeout=$OPTARG
            timeout_support $timeout
            ;;
        h) # help
            help
            exit 0
            ;;
        T) # test flag
            test_flag=true
            ;;
        *) # others are unknow
            echo "unknow argument"
            help
            exit 1
            ;;
    esac
done

if [ -z "$server" ] || [ -z "$server_port" ] || [ -z "$password" ] || [ -z "$method" ] || [ -z "$timeout" ]; then
    echo "Arguments are incomplete"
    help
    exit 1
fi

if [ -z "$name" ]; then
    name=ss_$server_port
fi

echo "Your config:"
echo "name_id: $name"
echo "server_port: $server_port"
echo "password: $password"
echo "method: $method"
echo "timeout: $timeout"

# generate supervisor config
supervisor_config="[program:$name]\n"
supervisor_config=$supervisor_config"command=docker run --rm "
# docker port map
supervisor_config=$supervisor_config"-p $server:$server_port:8388/tcp -p $server:$server_port:8388/udp "
# docker container name
supervisor_config=$supervisor_config"--name $name shadowsocks/shadowsocks-libev "
# ss-server command running in container
supervisor_config=$supervisor_config"ss-server -s 0.0.0.0 -p 8388 -k $password -m $method -t $timeout -u\n"
supervisor_config=$supervisor_config"user=root\n"
supervisor_config=$supervisor_config"autostart=true\nautoresart=true\nstartsecs=5\n"
supervisor_config=$supervisor_config"stopasgroup=true\nkillasgroup=true\n"
supervisor_config=$supervisor_config"stdout_logfile_maxbytes=5MB\n"
supervisor_config=$supervisor_config"stderr_logfile=/var/log/supervisor/ss_$server_port.stderr.log\n"
supervisor_config=$supervisor_config"stdout_logfile=/var/log/supervisor/ss_$server_port.stdout.log"
supervisor_config_file=$supervisor_configs_dir/$name.ini
rm -f $supervisor_config_file*
echo -e $supervisor_config > $supervisor_config_file

# auto command that is used to add user
if [ "$test_flag" != "true" ]; then
    sed -r "/\-P +$server_port/d" $users -i
    echo "$program $@" >> $users
fi

# supervisor update
echo "supervisor will update and this ss config will start."
supervisorctl -c $main_supervisor_config_file update

server_ip=`curl ip.sb 2>/dev/null`
ss_config=$method:$password@$server_ip:$server_port
echo "You can use this url to import to your shasowsocks client."
echo ss://`echo -n $ss_config | base64 | sed 's/+/-/g' | sed 's/\//_/g'`
