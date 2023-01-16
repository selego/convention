#!/bin/bash
set -e

##########
## MongoDB Atlas snapshots are a copy of the database files (WiredTiger storage engine) and must be copied in a new MongoDB instance in order to be read.
## This script download an existing MongoDB Atlas snapshot and open it in a local MongoDB instance.
## Notes:
##  `mongodb-org` and `mongodb-atlas-cli` packages must be installed on your host.
##  The snapshot URL can be added as an argument to the script, otherwise the last created snapshot will be downloaded from your Atlas cluster.
##  You can optionally do a database dump and close the local MongoDB instance.
##########

dbPath=backup
mkdir -p $dbPath
if [ "$1" != "" ]; then
    # use the snapshot URL specified as an argument
    snapshotUrl=$1
else
    # login into the MongoDB account, you can also use `atlas config init` with an API key
    atlas auth login || true

    # prompt for the cluster name (ex: "prod2" for Jobmaker)
    echo -n "Enter your MongoDB Atlas cluster name: "
    read clusterName

    # store the snapshot ID of the latest snapshot
    snapshotId=$(atlas backups snapshots list $clusterName --limit 1 -o json-path | awk 'NR==2{print $1}')
    echo "Got latest snapshot ($snapshotId)"

    # start the snapshot download process
    restoreJob=$(atlas backup restore start download --clusterName $clusterName --snapshotId $snapshotId -o json-path | awk -F"'" '{print $2}')
    echo "Snapshot download process started ($restoreJob)"

    # wait for the snapshot URL to be ready
    echo "Waiting for the snapshot download URL to be ready..."
    snapshotUrl=$(atlas backups restores describe $restoreJob --clusterName $clusterName -o json-path | awk 'NR==2{print $5}')
    while [ "$snapshotUrl" = "" ]
    do
      sleep 30
      snapshotUrl=$(atlas backups restores describe $restoreJob --clusterName $clusterName -o json-path | awk 'NR==2{print $5}')
    done
fi

# download and extract the snapshot db in the current folder
echo "Downloading snapshot from $snapshotUrl"
curl -o backup.tar.gz $snapshotUrl
tar -xvzf backup.tar.gz -C $dbPath --strip-components 1
rm backup.tar.gz

# start mongod with the snapshot db
mongod --dbpath backup --fork --logpath mongod.log

# optional: do a dump of this database then kill the mongod process
echo -n "Do you want to dump (then close) this database? (y/n): "
read dump
if [ "$dump" = "y" ]; then
  mongodump --uri="mongodb://127.0.0.1:27017"
  killall mongod
fi
