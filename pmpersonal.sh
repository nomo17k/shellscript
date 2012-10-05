#!/usr/bin/env bash
##############################################################################
# This is a script to run when AC/battery switches.  Ideally used
# within the power management configuration setting on KDE.  Requires
# tp_smapi to be loaded for the detection of AC/battery.
  
USERNAME=taro
LATITUDE=37.78
LONGITUDE=-122.42
  
  
##############################################################################
# DO NOT MODIFY BELOW
 
statuspath="/sys/class/power_supply/AC/online"
  
if [ ! -f "$statuspath" ]; then
    exit 0
fi
  
tag=pmpersonal
status=`cat "$statuspath"`
 
if [ "$status" = "1" ]; then
    logger -t $tag "on ac"
  
    logger -t $tag "start xflux"
    for i in `pgrep ^xflux$` ; do kill -9 $i ; done
    xflux -l $LATITUDE -g $LONGITUDE
  
    logger -t $tag "start dropbox"
    dropbox start
  
    logger -t $tag "enable system notification"
    kwriteconfig --file="/home/$USERNAME/.kde/share/config/knotifyrc" --group=Sounds --key="No sound" false
else
    logger -t $tag "on battery"
  
    logger -t $tag "stop xflux"
    for i in `pgrep ^xflux$` ; do kill -9 $i ; done
  
    logger -t $tag "stop dropbox"
    dropbox stop
  
    logger -t $tag "disable system notification"
    kwriteconfig --file="/home/$USERNAME/.kde/share/config/knotifyrc" --group=Sounds --key="No sound" true
fi
