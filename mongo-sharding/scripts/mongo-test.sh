###
# Общее число документов
###
docker exec mongos_router mongosh --port 27020 --quiet --eval '
const d = db.getSiblingDB("somedb");
print("total: " + d.helloDoc.countDocuments());
'

###
# Проверка по шардам
###
docker exec shard1 mongosh --port 27018 --quiet --eval 'print("shard1: " + db.getSiblingDB("somedb").helloDoc.countDocuments())'
docker exec shard2 mongosh --port 27019 --quiet --eval 'print("shard2: " + db.getSiblingDB("somedb").helloDoc.countDocuments())'

sleep 5

###
# Проверка роутеров
###
docker exec mongos_router mongosh --port 27020 --quiet --eval '
const routers = db.getSiblingDB("config").mongos.find().toArray();
print("routers: " + routers.length);
routers.forEach(r => print(" - " + r._id));
'