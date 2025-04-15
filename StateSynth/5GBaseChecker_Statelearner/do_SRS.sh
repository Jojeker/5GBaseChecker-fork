#! /bin/bash

pkill -9 mongo
mongod --fork --logpath /var/log/mongodb.log --dbpath /data/db --bind_ip_all
/OPEN5GS/misc/db/open5gs-dbctl add 001011234567895 00000000000000000000000064617665 64097b52589f63f12eec5172b49929d9


mkdir -p /data/coverage

rm start_ue.sh
ln -s start_srs_ue.sh start_ue.sh

rm start_gnb.sh
ln -s start_srs_gnb.sh start_gnb.sh

./start_learner.sh srsue