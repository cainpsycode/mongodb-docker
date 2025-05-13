#!/bin/sh
set -e

# Стартуем mongod без авторизации (в фоне)
mongod --fork --logpath /var/log/mongod.log --smallfiles

# Ждём, пока mongod поднимется
sleep 5

# Если переменная не задана — просто запускаем mongod без создания пользователя
if [ -z "$MONGO_ROOT_PASSWORD" ]; then
  echo "MONGO_ROOT_PASSWORD not set, skipping user creation"
  mongod --shutdown
  exec mongod
fi

echo "Creating root user in MongoDB..."

# Команда для создания пользователя
js="if (!db.getUser('root')) {
  db.createUser({
    user: 'root',
    pwd: '$MONGO_ROOT_PASSWORD',
    roles: [ 'userAdminAnyDatabase', 'readWriteAnyDatabase' ]
  });
} else {
  print('User root already exists');
}"

mongo admin --eval "$js"

# Останавливаем Mongo
mongod --shutdown

# Запускаем заново в foreground (теперь можно с авторизацией, если хочешь)
exec mongod $MONGO_OPTIONS
