#!/bin/bash

if [ "$EUID" -ne 0 ]
	then echo "Need to run as root"
	exit
fi

echo "Killing open5gs"
pkill -9 -f 5gc
echo "Killing any already running srsepc process"
pkill -9 open5gs

echo "Kiliing the core_statelearner server listening on port 60000"
# kill -9 $(lsof -t -i:60000)

echo "Killed open5gs"
