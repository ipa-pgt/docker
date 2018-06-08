#!/bin/bash

set -e

DIR_ICI="${1:-$(rospack find industrial_ci)}"
source $DIR_ICI/src/util.sh
source $DIR_ICI/src/docker.sh

DIR_THIS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HEADER="# DO NOT EDIT!\n# This file  was auto-generated with ./sync.sh at $(LC_ALL=C date)\n"
INJECT_MAINTAINER="/^FROM/a LABEL MAINTAINER \"$(git config --get user.name)\" <$(git config --get user.email)>"

function export_dockerfile {
    echo $*
    ROS_DISTRO=$1
    ROS_REPO=$2
    OS_NAME=
    OS_CODE_NAME=
    DOCKER_BASE_IMAGE=
    ROS_REPOSITORY_PATH=

    source $DIR_ICI/src/env.sh
    OS_CODE_NAME=${3:-$OS_CODE_NAME}
    DOCKER_BASE_IMAGE=${4:-$DOCKER_BASE_IMAGE}

    local path=$DIR_THIS/$ROS_DISTRO-${5:-$OS_CODE_NAME}${ROS_REPO#ros}
    mkdir -p "$path"

    echo -e "$HEADER" > $path/Dockerfile
    ici_generate_default_dockerfile | sed "$INJECT_MAINTAINER" >> $path/Dockerfile
}

for r in ros ros-shadow-fixed; do
    for d in hydro indigo jade kinetic lunar melodic; do
        export_dockerfile $d $r
    done
    export_dockerfile kinetic $r jessie debian:jessie
    export_dockerfile lunar $r yakkety
    export_dockerfile lunar $r zesty
    export_dockerfile lunar $r stretch debian:stretch
    export_dockerfile melodic $r stretch debian:stretch
    export_dockerfile melodic $r artful
    
    export_dockerfile indigo $r trusty ros:indigo-ros-core-trusty ros-core-trusty
    export_dockerfile indigo $r trusty ros:indigo-ros-core-trusty ros-core
    export_dockerfile kinetic $r xenial ros:kinetic-ros-core-xenial ros-core-xenial
    export_dockerfile kinetic $r xenial ros:kinetic-ros-core-xenial ros-core
    export_dockerfile kinetic $r jessie ros:kinetic-ros-core-jessie ros-core-jessie
    export_dockerfile lunar $r xenial ros:lunar-ros-core-xenial ros-core-xenial
    export_dockerfile lunar $r xenial ros:lunar-ros-core-xenial ros-core
    export_dockerfile lunar $r stretch ros:lunar-ros-core-stretch ros-core-stretch
    export_dockerfile melodic $r bionic ros:melodic-ros-core-bionic ros-core-bionic
    export_dockerfile melodic $r bionic ros:melodic-ros-core-bionic ros-core
    export_dockerfile melodic $r stretch ros:melodic-ros-core-stretch ros-core-stretch
done

