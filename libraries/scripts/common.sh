# bash include for common functions/vars

# Intended to run directly after a long-running task,
# i.e., doit & wait_progress "doit"
function wait_progress()
{
    local pid=$!
    local msg=$1
    local delay=0.25
    local str_color=(1 2 3 4 5 6 7)
    local str_l=${#str_color[@]}
    local str_color_l=${#str_color[@]}
    local index=0
    local index_c=0
    local _FAIL="[$(tput setaf 1)LIB$(tput sgr0)]"
    local _SUCCESS="[$(tput setaf 2)LIB$(tput sgr0)]"

    [[ -z $msg ]] && {
        msg="Waiting..."
    }

    if [[ -t 1 ]]; then
        # produces spinner indicator
        while kill -0 $pid &>/dev/null; do
            echo -ne "\r[$(tput setaf $index_c)LIB$(tput sgr0)]    $msg  "
            sleep $delay
            index=$(( $(( $index + 1 )) % $str_l ))
            index_c=$(( $(( $index_c + 1 )) % $str_color_l ))
        done
    else
        # or a simpler indicator
        echo -en "\r[...] $msg"
    fi

    # block
    if wait $pid ; then
        ret=$?
        echo -en "\r$_SUCCESS    $msg    \n"
    else
        ret=$?
        echo -en "\r$_FAIL     $msg       \n"
    fi

    return $ret
}

# Error wrapper
function die()
{
    echo "Fail: $1"
    exit 1
}

function num_cpus()
{
    echo $(grep -c ^processor /proc/cpuinfo)
}

# Retrieves lib name from script
function get_lib_name()
{
    printf "%s" "$(basename ${1%.*})"
}

function get_src_dir()
{
    printf "%s" "libraries/srcs"
}

function get_log_dir()
{
    printf "%s" "libraries/logs"
}

function get_log_name()
{
    printf "%s" "$(basename ${1%.*}).log-${2}"
}

THIS="$(basename "$0")"
THIS_DIR="$(dirname $(readlink -f $0))"
LOG="$(get_log_dir)/$(get_log_name $THIS $2)"
DEBUG=0
