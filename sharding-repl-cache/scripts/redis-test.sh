URL="http://localhost:8080/helloDoc/users"

# очистка кэша
echo "== Flush Redis =="
for i in 1 2 3 4 5 6; do
  docker exec redis_$i sh -c \
    'redis-cli info replication | grep -q "role:master" && redis-cli flushall >/dev/null && echo "$(hostname): flushed"'
done

timing() {
  curl -s -o /dev/null -w "%{http_code} %{time_total}" "$URL"
}

# 2) Первый запрос: кэш пуст, идём в Mongo
echo "== Request 1 (cache MISS) =="
read -r code1 t1 < <(timing)
echo "status=$code1 time=${t1}s"

# Ключи в Redis после первого запроса
echo "== Keys in cluster =="
for i in 1 2 3 4 5 6; do
  docker exec redis_$i sh -c \
    'redis-cli info replication | grep -q "role:master" && echo "$(hostname): $(redis-cli dbsize) keys"'
done

# 3) Второй запрос: должен прийти из кэша
echo "== Request 2 (cache HIT) =="
read -r code2 t2 < <(timing)
echo "status=$code2 time=${t2}s"

echo "== Result =="
echo "miss: ${t1}s | hit: ${t2}s"