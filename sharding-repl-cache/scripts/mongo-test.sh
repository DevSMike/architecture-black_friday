###
# Общее число документов
###
docker exec mongos_router mongosh --port 27024 --quiet --eval '
const d = db.getSiblingDB("somedb");
print("total: " + d.helloDoc.countDocuments());
'

###
# Количество шардов
###
docker exec mongos_router mongosh --port 27024 --quiet --eval '
const shards = db.adminCommand({ listShards: 1 }).shards;
print("shards: " + shards.length);
shards.forEach(s => print(" - " + s._id + " -> " + s.host));
'

###
# Проверка по шардам на данные
###
docker exec mongo1_1 mongosh --port 27018 --quiet --eval 'print("mongo1_1: " + db.getSiblingDB("somedb").helloDoc.countDocuments())'
docker exec mongo1_2 mongosh --port 27019 --quiet --eval 'print("mongo1_2: " + db.getSiblingDB("somedb").helloDoc.countDocuments())'
docker exec mongo1_3 mongosh --port 27020 --quiet --eval 'print("mongo1_3: " + db.getSiblingDB("somedb").helloDoc.countDocuments())'

docker exec mongo2_1 mongosh --port 27021 --quiet --eval 'print("mongo2_1: " + db.getSiblingDB("somedb").helloDoc.countDocuments())'
docker exec mongo2_2 mongosh --port 27022 --quiet --eval 'print("mongo2_2: " + db.getSiblingDB("somedb").helloDoc.countDocuments())'
docker exec mongo2_3 mongosh --port 27023 --quiet --eval 'print("mongo2_3: " + db.getSiblingDB("somedb").helloDoc.countDocuments())'

###
# Роли узлов в реплика-сетах
###
docker exec mongo1_1 mongosh --port 27018 --quiet --eval '
const s = rs.status();
print("replica set: " + s.set);
s.members.forEach(m => print(" - " + m.name + " " + m.stateStr));
'

docker exec mongo2_1 mongosh --port 27021 --quiet --eval '
const s = rs.status();
print("replica set: " + s.set);
s.members.forEach(m => print(" - " + m.name + " " + m.stateStr));
'

###
# Проверка роутеров
###
docker exec mongos_router mongosh --port 27024 --quiet --eval '
const routers = db.getSiblingDB("config").mongos.find().toArray();
print("routers: " + routers.length);
routers.forEach(r => print(" - " + r._id));
'