#!/bin/bash

###
# Инициализация сервера конфигурации
###
docker exec configSrv mongosh --port 27017 --quiet --eval '
rs.initiate({
  _id: "config_server",
  configsvr: true,
  members: [{ _id: 0, host: "configSrv:27017" }]
})'

sleep 5

###
# Инициализация шардов с репликами
###
docker exec shard1_1 mongosh --port 27018 --quiet --eval 'rs.initiate({_id:"rs0",members:[
{_id:0,host:"shard1_1:27018"},
{_id:1,host:"shard1_2:27019"},
{_id:2,host:"shard1_3:27020"}
]})'

docker exec shard2_1 mongosh --port 27021 --quiet --eval 'rs.initiate({_id:"rs1",members:[
{_id:0,host:"shard2_1:27021"},
{_id:1,host:"shard2_2:27022"},
{_id:2,host:"shard2_3:27023"}
]})'

sleep 5

###
# Подключение шардов и включение шардирования: хеш шардирование по ключу name
###
docker exec mongos_router mongosh --port 27024 --quiet --eval '
sh.addShard("rs0/shard1_1:27018,shard1_2:27019,shard1_3:27020");
sh.addShard("rs1/shard2_1:27021,shard2_2:27022,shard2_3:27023");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { name: "hashed" });
'

###
# Наполнение данными
###
docker exec mongos_router mongosh --port 27024 --quiet --eval '
const d = db.getSiblingDB("somedb");
const docs = [];
for (let i = 0; i < 1000; i++) docs.push({ age: i, name: "ly" + i });
d.helloDoc.insertMany(docs);
print("total: " + d.helloDoc.countDocuments());
'