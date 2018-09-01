#!/usr/bin/env bash

SRC_DIR=$(readlink -f $0)
SRC_DIR=$(dirname $SRC_DIR)
DIST_DIR="$SRC_DIR/target/dist"
CONFIG="$DIST_DIR/tale/resources/application.properties"

# make package
mvn clean package -Pprod -Dmaven.test.skip=true

# modfiy release config
[ -d "$DIST_DIR" ] || exit -1
[ -f "$CONFIG" ] || exit -1
sed -i "s/app.devMode=.*/app.devMode=false/g" "$CONFIG"
sed -i "s/server.port=.*/server.port=80/g" "$CONFIG"

# copy 
cp "$SRC_DIR/start.sh" "$DIST_DIR/tale/start.sh"
cp "$SRC_DIR/tale.service" "$DIST_DIR/tale/tale.service"
cp "$SRC_DIR/install.sh" "$DIST_DIR/tale/install.sh"

# tar package
cd "$DIST_DIR"
tar -zcf "$SRC_DIR/tale.tar.gz" tale

exit 0
