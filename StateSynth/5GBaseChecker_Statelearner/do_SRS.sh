#! /bin/bash

pkill -9 mongo
mongod --fork --logpath /var/log/mongodb.log --dbpath /data/db --bind_ip_all
/OPEN5GS/misc/db/open5gs-dbctl add 001011234567895 00000000000000000000000064617665 64097b52589f63f12eec5172b49929d9


mkdir -p /data/coverage

rm start_ue.sh
ln -s start_srs_ue.sh start_ue.sh

rm start_gnb.sh
ln -s start_srs_gnb.sh start_gnb.sh

# Start the script in the background and save its PID
./start_learner.sh srsue &
LEARNER_PID=$!

# Set a 24-hour timer (24h * 60m * 60s = 86400 seconds)
(
    sleep 86400
    echo "24 hours passed, stopping all processes"
    kill -9 $LEARNER_PID
    pkill -9 java # For good measure
    pkill -9 mongo
    # Add any other cleanup processes needed
    exit 0
) &

# Wait for the learner process
wait $LEARNER_PID