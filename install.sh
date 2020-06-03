#!/bin/sh
# Install script for NautyTracesInterface

set -e

help() {
cat <<EOF
Usage: $0 [OPTIONS]

Build NautyTracesInterface

Actions
  -h,  --help                      display this help text and exit

Paths
  --gaproot <path>                 Set GAP root path (default is ../..)
  --nauty <path>                   Path to nauty (default is nauty27r1)

Notes
* Please note that NautyTracesInterface needs a patched version of Nauty.
  If you use a different version of Nauty as the one that comes with
  NautyTracesInterface, make sure you have compiled all object files with -fPIC.

EOF
    exit 0
}

error() {
    printf "\033[31mERROR: %s\033[0m\n" "$*"
    exit 1
}

CURRENT_DIR=${PWD}
NAUTY_PATH=${PWD}/nauty27r1
GAPROOT=../..

while [ x"$1" != x ]; do
  option="$1" ; shift
  case "$option" in
    -h | --help ) help ;;

    --gaproot ) GAPROOT="$1"; shift ;;
    --nauty ) NAUTY_PATH="$1"; shift ;;
    -- ) break ;;
    * ) error "unknown option '$option'" ;;
  esac
done

cd $NAUTY_PATH
./configure
make

cd $CURRENT_DIR
./autogen.sh
./configure --with-gaproot=${GAPROOT} --with-nauty=${NAUTY_PATH}
make

exit 0
