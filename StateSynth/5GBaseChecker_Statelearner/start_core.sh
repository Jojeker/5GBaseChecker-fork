#!/bin/bash
#echo "USENIX24" | sudo -S ./start_core.sh 

if [ "$EUID" -ne 0 ]
	then echo "Need to run as root"
	exit
fi

echo "Launching start_core.sh"

echo "Killing any already running srsepc process"
pkill -9 -f open5gs
pkill -9 -f 5gc
# ps -ef | grep open5gs | grep -v grep | awk '{print $2}' | xargs kill -2

echo "Killing the core_statelearner server listening on port 60000"

echo "Killing done!"

sleep 1

echo "Running in Docker environment"
5gc -c /conf/Open5GS/open5gs.yaml &> /tmp/core_fuzzing.log &

echo "Finished launching start_core.sh"
