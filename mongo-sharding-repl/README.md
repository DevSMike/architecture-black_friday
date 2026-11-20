# pymongo-api

## Как запустить

Запускаем mongodb и приложение

```shell
docker compose up -d
```

Заполняем mongodb данными

```shell
./scripts/mongo-init.sh
```

## Как проверить

```shell
./scripts/mongo-test.sh
```

Корректный вывод:
```json lines
$ ./scripts/mongo-test.sh
total: 1000
shards: 2
- rs0 -> rs0/shard1_1:27018,shard1_2:27019,shard1_3:27020
- rs1 -> rs1/shard2_1:27021,shard2_2:27022,shard2_3:27023
shard1_1: 492
shard1_2: 492
shard1_3: 492
shard2_1: 508
shard2_2: 508
shard2_3: 508
replica set: rs0
- shard1_1:27018 PRIMARY
- shard1_2:27019 SECONDARY
- shard1_3:27020 SECONDARY
replica set: rs1
- shard2_1:27021 PRIMARY
- shard2_2:27022 SECONDARY
- shard2_3:27023 SECONDARY
routers: 2
- b15257e5fa4b:27024
- b105038cd3cc:27025

```
### Если вы запускаете проект на локальной машине

Откройте в браузере http://localhost:8080

### Если вы запускаете проект на предоставленной виртуальной машине

Узнать белый ip виртуальной машины

```shell
curl --silent http://ifconfig.me
```

Откройте в браузере http://<ip виртуальной машины>:8080

## Доступные эндпоинты

Список доступных эндпоинтов, swagger http://<ip виртуальной машины>:8080/docs