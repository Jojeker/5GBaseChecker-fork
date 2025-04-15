#!/bin/bash
#echo "USENIX24" | sudo -S ./start_gnb.sh

if [ "$EUID" -ne 0 ]
	then echo "Need to run as root"
	exit
fi

echo "Launching start_srs_gnb.sh"

echo "Killing any already running srsgnb process"
pkill -9 -f srsenb
# ps -ef | grep srsenb | grep -v grep | awk '{print $2}' | xargs sudo kill -9

echo "Killing the enodeb_statelearner server listening on port 60000"
#sudo kill $(lsof -t -i:60001)
#kill -9 $(lsof -t -i:60001)

source_dir=`pwd`

# Use relative paths and cd into the configs directory, which should be picked up...
CONFIG_DIR=../modified_cellular_stack/conf/srs_gnb/provided
TARGET_DIR=../../../5GBaseChecker_srs_gnb/build/srsenb/src

rm /tmp/enb_fuzzing.log

# Check if DOCKER_EXP environment variable is defined
echo "Running in Docker environment"
srsenb /conf/srs_gnb/provided/enb.conf &> /tmp/srs_enb_fuzzing.log &

sleep 1

cd "$source_dir"

echo "srsenb is running in the background"
echo "log is saved to /tmp/enb_fuzzing.log"
echo "Finished lauching start_srs_gnb.sh"
