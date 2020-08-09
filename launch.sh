#!/bin/bash

WITH_CUDA=0
ON_MAC=0

function usage()
{
    echo "A script that builds a docker container with CUDA & Ubuntu 18.04 and runs a little program through it to test the installation of OpenCV with (or without) CUDA support"
    echo ""
    echo "bash launch.sh"
    echo "  h --help"
    echo "  --with_cuda=$WITH_CUDA"
    echo "  --on_mac=$ON_MAC"
    echo ""
}

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        --with_cuda)
            WITH_CUDA=$VALUE
            ;;
        --on_mac)
            ON_MAC=$VALUE
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done

echo "Arg values:"
echo "> WITH_CUDA: $WITH_CUDA"
echo "> ON_MAC: $ON_MAC"
_nproc=0
if [ $ON_MAC -eq 0 ]; then
    _nproc=$(nproc)
else
    _nproc=$(sysctl -n hw.physicalcpu)
fi
available_proc=$((_nproc - 1))
if [ $WITH_CUDA -eq 1 -a $ON_MAC -eq 0 ]; then
    docker build --build-arg USE_CUDA=ON -t opencv440-cuda11:1 .
    docker run --rm -it --gpus all --cpuset-cpus="0-$available_proc" -u $(id -u) opencv440-cuda11:1 hello_world
else
    docker build --build-arg USE_CUDA=OFF -t opencv440-without-cuda:1 .
    docker run --rm -it --cpuset-cpus="0-$available_proc" -u $(id -u) opencv440-without-cuda:1 hello_world
fi
