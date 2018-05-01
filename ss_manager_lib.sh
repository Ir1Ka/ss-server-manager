# This file is ss manager lib, and it cannot executed alone. 

main_supervisor_config_dir=/root/supervisor
main_supervisor_config_file=$main_supervisor_config_dir/supervisord.conf

#ss_configs_dir=/root/shadowsocks/ss_configs
supervisor_configs_dir=/root/shadowsocks/supervisor_configs

users="$DIR/users.sh"

# default value
server=0.0.0.0
timeout=300
method=aes-128-gcm

# functions
function is_port_number() {
    case "$1" in
        [1-9][0-9]*)
            if [ $1 -gt 65535 ]; then
                echo "$1 is greater than 65535."
                return 1
            fi
            ;;
        *)
            echo "$1 is not a server port."
            return 1
            ;;
    esac
    return 0
}

function method_support() {
    methods=(rc4-md5 aes-128-gcm aes-192-gcm aes-256-gcm
             aes-128-cfb aes-192-cfb aes-256-cfb
             aes-128-ctr aes-192-ctr aes-256-ctr
             camellia-128-cfb camellia-192-cfb
             camellia-256-cfb bf-cfb
             chacha20-ietf-poly1305
             xchacha20-ietf-poly1305
             salsa20 chacha20 chacha20-ietf)
    method=`echo $1 | tr '[A-Z]' '[a-z]'`
    for m in ${methods[@]}; do
        if [ "$m" == "$method" ]; then
            return 0
        fi
    done
    echo "$1 method is not support."
    return 1
}

function timeout_support() {
    case "$1" in
        [1-9][0-9]*)
            if [ $1 -gt 600 ] || [ $1 -lt 50 ]; then
                echo "$1 is too long or too short. It should be between 50 and 600."
                return 1
            fi
            ;;
        *)
            echo "$1 is not a positive integer, but need it here as a timeout."
            return 1
            ;;
    esac
    return 0
}

# Get container IP address.
function container_ip() {
    if [ -z "$1" ]; then
        echo "$FUNCNAME function needs a container name or id."
    fi
    docker inspect --format '{{ .NetworkSettings.IPAddress }}' $1
}

# Get container net.
function container_net() {
    if [ -z "$1" ]; then
        echo "$FUNCNAME function needs a container name or id."
        return 1
    fi
    docker stats --no-stream --format "table {{.NetIO}}" $1 | sed '1d'
}

# Only get net input as bytes.
function container_net_in() {
    net_io=`container_net $1`
    tmp_dir=/tmp/docker/ss
    mkdir -p $tmp_dir
    tmp_file=$tmp_dir/$1.net.in
    echo ${net_io%% / *} > $tmp_file
    awk '{sum=/TB/?$0*(1000^4):(/GB/?$0*(1000^3):(/MB/?$0*(1000^2):(/KB/?$0*1000:$0)))}END{printf "%.dBytes\n", sum}' $tmp_file
}

# Only get net output as bytes.
function container_net_out() {
    net_io=`container_net $1`
    tmp_dir=/tmp/docker/ss
    mkdir -p $tmp_dir
    tmp_file=$tmp_dir/$1.net.out
    echo ${net_io##* / } > $tmp_file
    awk '{sum=/TB/?$0*(1000^4):(/GB/?$0*(1000^3):(/MB/?$0*(1000^2):(/KB/?$0*1000:$0)))}END{printf "%.dBytes\n", sum}' $tmp_file
}

# Get Unix timestamps.
function container_created_timestamps() {
    if [ -z "$1" ]; then
        echo "$FUNCNAME function needs a container name or id."
        return 1
    fi
    date -d `docker inspect --format '{{ .Created }}' $1` +%s
}

# Get port forom name
function container_port() {
    if [ -z "$1" ]; then
        echo "$FUNCNAME function needs a container name or id."
        return 1
    fi
    docker inspect --format '{{(index (index .HostConfig.PortBindings "8388/tcp") 0).HostPort}}' $1
}
