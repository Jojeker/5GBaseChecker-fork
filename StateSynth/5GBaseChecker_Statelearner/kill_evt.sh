#!/bin/bash


if [ "$EUID" -ne 0 ]
	then echo "Need to run as root"
	exit
fi

source_dir=`pwd`

pkill srsue
pkill -9 -f srsenb
pkill -9 -f 5gc
ps -ef | grep open5gs | grep -v grep | awk '{print $2}' | xargs kill -9
pkill -9 open5gs

