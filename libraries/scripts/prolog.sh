# Import base functions/vars
source "$(dirname $(readlink -f $0))"/common.sh || {
    echo "Cannot find $(dirname $(readlink -f $0))/common.sh. Exiting."
    exit 1
}

function install1()
{
    [[ -z "$1" ]] && {
        echo "$FUNCNAME \$1 empty"
        exit 2
    }

    cd "$(get_src_dir)/$(get_lib_name $THIS)" \
        || die "Could not change into src directory for library"
    
    (( DEBUG )) && echo "In dir: $(pwd)"
    (( DEBUG )) && echo "Building $(get_lib_name $THIS)"

    install

    exit 0

} &>> "$LOG"

function clean1()
{
    [[ -z "$1" ]] && {
        echo "$FUNCNAME \$1 empty"
        exit 2
    }

    (( DEBUG )) && "Cleaning $(get_lib_name $THIS) - $1"

    clean

    exit 0

} &>> "$LOG"

