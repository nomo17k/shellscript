#!/bin/bash

if [ ! -f /sys/devices/platform/smapi/ac_connected ]; then
    exit 0
fi

TAG=pmkde
STATUS=`cat /sys/devices/platform/smapi/ac_connected`

if [ "$STATUS" = "1" ]; then
    logger -t $TAG "on ac"

    logger -t $TAG "start xflux"
    for i in `pgrep ^xflux$` ; do kill -9 $i ; done
    xflux -l 44.65 -g -63.6

    logger -t $TAG "start dropbox"
    for i in `pgrep ^dropbox$` ; do kill -9 $i ; done
    /usr/local/dropbox/dropboxd &

    logger -t $TAG "enable system notification"
    kwriteconfig --file=/home/taro/.kde/share/config/knotifyrc --group=Sounds --key="No sound" false
else
    logger -t $TAG "on battery"

    logger -t $TAG "stop xflux"
    for i in `pgrep ^xflux$` ; do kill -9 $i ; done

    logger -t $TAG "stop dropbox"
    for i in `pgrep ^dropbox$` ; do kill -9 $i ; done

    logger -t $TAG "disable system notification"
    kwriteconfig --file=/home/taro/.kde/share/config/knotifyrc --group=Sounds --key="No sound" true
fi
