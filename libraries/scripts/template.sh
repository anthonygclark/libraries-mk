#!/bin/bash
source "$(dirname $(readlink -f $0))"/prolog.sh

# When this function enters, `pwd` is libraries/srcs/<this lib>
function install()
{
    printenv
    sleep 1
}

# When this function enters, `pwd` is libraries/srcs/<this lib>
function clean()
{
    sleep 1
}

source "$(dirname $(readlink -f $0))"/epilog.sh
