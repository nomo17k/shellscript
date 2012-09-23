#!/bin/bash
##############################################################################
# This is a script to run when AC/battery switches.  Ideally used
# within the power management configuration setting on KDE.  Requires
# tp_smapi to be loaded for the detection of AC/battery.

USERNAME=taro
LATITUDE=37.78
LONGITUDE=-122.42


##############################################################################
# DO NOT MODIFY BELOW 

if [ ! -f /sys/devices/platform/smapi/ac_connected ]; then
    exit 0
fi

TAG=pmpersonal
STATUS=`cat /sys/devices/platform/smapi/ac_connected`

if [ "$STATUS" = "1" ]; then
    logger -t $TAG "on ac"

    logger -t $TAG "start xflux"
    for i in `pgrep ^xflux$` ; do kill -9 $i ; done
    xflux -l $LATITUDE -g $LONGITUDE

    logger -t $TAG "start dropbox"
    dropbox stop
    dropbox start

    logger -t $TAG "enable system notification"
    kwriteconfig --file="/home/$USERNAME/.kde/share/config/knotifyrc" --group=Sounds --key="No sound" false
else
    logger -t $TAG "on battery"

    logger -t $TAG "stop xflux"
    for i in `pgrep ^xflux$` ; do kill -9 $i ; done

    logger -t $TAG "stop dropbox"
    dropbox stop

    logger -t $TAG "disable system notification"
    kwriteconfig --file="/home/$USERNAME/.kde/share/config/knotifyrc" --group=Sounds --key="No sound" true
fi
