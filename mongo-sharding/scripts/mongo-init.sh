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
# Инициализация шардов (реплика-сеты из одного узла)
###
docker exec shard1 mongosh --port 27018 --quiet --eval 'rs.initiate({_id:"shard1",members:[{_id:0,host:"shard1:27018"}]})'
docker exec shard2 mongosh --port 27019 --quiet --eval 'rs.initiate({_id:"shard2",members:[{_id:0,host:"shard2:27019"}]})'

sleep 5

###
# Подключение шардов и включение шардирования: хеш шардирование по ключу name
###
docker exec mongos_router mongosh --port 27020 --quiet --eval '
sh.addShard("shard1/shard1:27018");
sh.addShard("shard2/shard2:27019");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { name: "hashed" });
'

###
# Наполнение данными
###
docker exec mongos_router mongosh --port 27020 --quiet --eval '
const d = db.getSiblingDB("somedb");
const docs = [];
for (let i = 0; i < 1000; i++) docs.push({ age: i, name: "ly" + i });
d.helloDoc.insertMany(docs);
print("total: " + d.helloDoc.countDocuments());
'