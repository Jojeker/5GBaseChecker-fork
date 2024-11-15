#!/bin/bash
#echo "USENIX24" | sudo -S ./start_gnb.sh

if [ "$EUID" -ne 0 ]
	then echo "Need to run as root"
	exit
fi

echo "Launching start_oai_gnb.sh"

echo "Killing any already running OAI nr-softmodem process"
pkill -9 -f nr-softmodem

#echo "Kiliing the enodeb_statelearner server listening on port 60000"
#sudo kill $(lsof -t -i:60001)
#kill -9 $(lsof -t -i:60001)

source_dir=$(pwd)

cd ../modified_cellular_stack/5GBaseChecker_OAI_gnb/cmake_targets/ran_build/build

rm /tmp/OAIgNB_fuzzing.log

# ./nr-softmodem -O ../../../targets/PROJECTS/GENERIC-NR-5GC/CONF/gnb.sa.band78.fr1.106PRB.usrpb210.conf -E --sa --usrp-tx-thread-config 1 --continuous-tx &> /tmp/OAIgNB_fuzzing.log &
./nr-softmodem -O ../../../targets/PROJECTS/GENERIC-NR-5GC/CONF/gnb.sa.band78.fr1.106PRB.usrpb210.conf -E --sa --usrp-tx-thread-config 1 --continuous-tx --rfsim --gNBs.[0].min_rxtxtime 6 2&1> /tmp/OAIgNB_fuzzing.log &

cd "$source_dir"

echo "srsenb is running in the background"
echo "log is saved to /tmp/OAIgNB_fuzzing.log"
echo "Finished lauching start_gnb.sh"

