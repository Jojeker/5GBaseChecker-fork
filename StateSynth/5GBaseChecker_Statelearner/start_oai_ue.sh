#!/bin/bash

if [ "$EUID" -ne 0 ]
	then echo "Need to run as root"
	exit
fi

echo "Launching start_oai_ue.sh"

echo "Killing any already running srsue process"
pkill -9 -f nr-uesoftmodem


source_dir=`pwd`

cd ../modified_cellular_stack/5GBaseChecker_OAI_gnb/cmake_targets/ran_build/build/

rm /tmp/OAIue_fuzzing.log

./nr-uesoftmodem -r 106 --numerology 1 --band 78 -C 3619200000 --sa --ue-fo-compensation -E -O ../../../targets/PROJECTS/GENERIC-NR-5GC/CONF/ue.conf --dlsch-parallel 8 --rfsim

sleep 1

cd "$source_dir"

echo "oaiue is running in the background"
echo "log is saved to /tmp/OAIue_fuzzing.log"
echo "Finished lauching start_oai_ue.sh"

