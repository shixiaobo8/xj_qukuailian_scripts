#!/usr/bin/env bash
# 备份mongodb 数据库
source /etc/profile
today=`date +%Y_%m_%d`
mkdir -p /data/mongo_backups/
cd /data/mongo_backups/
mongodump --port 21000 -u Sadmin1 -p Spa123456  --authenticationDatabase admin  >> /tmp/mongodump.log 2>&1
tar -zcvf dump_$today.tar.gz ./dump
rm -rf ./dump
find ./ -mtime 3 | xargs rm -rf 
