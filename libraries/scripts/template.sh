#!/bin/bash

function install()
{
    [[ -z "$1" ]] && {
        echo "$FUNCNAME \$1 empty"
        exit 2
    }
    
    (( DEBUG )) && echo "Building $(get_lib_name $THIS) - $1"

    cd "$(get_src_dir)/$(get_lib_name $THIS)" \
        || die "Could not change into src directory for library"
    
    (( DEBUG )) && echo "In dir: $(pwd)"

    # DO WORK HERE
    printenv
    sleep 5

    exit 0

} &>> "$LOG"

function clean()
{
    [[ -z "$1" ]] && {
        echo "$FUNCNAME \$1 empty"
        exit 2
    }

    (( DEBUG )) && "Cleaning $(get_lib_name $THIS) - $1"

    # DO WORK HERE
    sleep 3

    exit 0

} &>> "$LOG"

# Import base functions/vars
source "$(dirname $(readlink -f $0))"/common.sh || {
    echo "Cannot find ${THIS_DIR}/common.sh. Exiting."
    exit 1
}

(( DEBUG )) && echo "Invoking $THIS with args = $@"

echo "**** $(date) ****" | tee "$LOG"
eval "${1} ${2}" & wait_progress "${THIS} (${2})"

