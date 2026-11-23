# pymongo-api

## Как запустить

Запускаем mongodb и приложение

```shell
docker compose up -d
```

Заполняем mongodb данными

```shell
./scripts/mongo-init.sh
./scripts/redis-init.sh
```


## Как проверить

```shell
./scripts/redis-test.sh
```

Корректный вывод (запись попала в кеш и повторный запрос был обработан быстрее):
```json lines
$ ./scripts/redis-test.sh
== Flush Redis ==
ad168f19cd20: flushed
c937d3f6c171: flushed
fae101ebac05: flushed
== Request 1 (cache MISS) ==
status=200 time=1.162370s
== Keys in cluster ==
ad168f19cd20: 0 keys
c937d3f6c171: 1 keys
fae101ebac05: 0 keys
== Request 2 (cache HIT) ==
status=200 time=0.008013s
== Result ==
miss: 1.162370s | hit: 0.008013s

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