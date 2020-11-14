set -e
PKG_DIR=`dirname "$0"`
cd $PKG_DIR/nauty2*r* && ./configure && make
