#!/bin/bash
set -o errexit # Exit on error
SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`
SRC="$SCRIPTPATH/log"
#echo $SCRIPTPATH
echo $SRC

cd ~/openpilot/tools
pipenv run python replay/ui.py &
pipenv run python replay/unlogger.py "f9801d8be3dcbab5" $SRC

trap 'kill $(jobs -p)' EXIT
