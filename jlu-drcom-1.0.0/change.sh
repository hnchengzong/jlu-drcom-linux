#!/bin/sh
##change the privillege of drcomauthsvr
APPNAME=drcomauthsvr
FULLPATH=$1/$APPNAME
echo "$FULLPATH"
chown root:root "$FULLPATH"
chmod 4755 "$FULLPATH"
