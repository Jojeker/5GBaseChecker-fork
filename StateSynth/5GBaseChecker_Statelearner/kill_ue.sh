#!/bin/bash

if [ "$EUID" -ne 0 ]
	then echo "Need to run as root"
	exit
fi

echo -n "Killing srsUE... "

pkill -9 -f srsue

echo "[OK]"
