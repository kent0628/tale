#!/usr/bin/env bash

SRC_DIR=$(readlink -f $0)
SRC_DIR=$(dirname $SRC_DIR)
APP_DIR="/root/tale"

if [ -d "$APP_DIR" ]; then
	# stop
	systemctl stop tale
	# backup
	/root/tale_backup.sh
	# copy
	cp "$APP_DIR/resources/tale.db" "$SRC_DIR/resources/tale.db"
	cp "$APP_DIR/resources/install.lock" "$SRC_DIR/resources/install.lock"
	cp -r "$APP_DIR/logs" "$SRC_DIR"
	# remove
	rm -rf "$APP_DIR"
	# install
	rm $0
	mv "$SRC_DIR" "$APP_DIR"
	# start
	systemctl restart tale
else
	rm $0
	cp "$SRC_DIR/tale.service" /etc/systemd/system/tale.service
	mv "$SRC_DIR" "$APP_DIR"
	systemctl enable tale && systemctl restart tale
fi

exit 0
