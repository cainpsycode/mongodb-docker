#!/bin/sh
# Проверка, задан ли пароль root-пользователя MongoDB
if [ -z "$MONGO_ROOT_PASSWORD" ]; then
  exit 0
fi
# Запуск фонового процесса
(
  # Ожидание запуска MongoDB
  sleep 5
  # Команда авторизации
  auth="-u root -p $MONGO_ROOT_PASSWORD"
  # JS-скрипт на создание пользователя root (если его нет)
  js="if (!db.getUser('root')) {
    db.createUser({
      user: 'root',
      pwd: '$MONGO_ROOT_PASSWORD',
      roles: [ 'userAdminAnyDatabase' ]
    });
  }"
  # Цикл попыток подключения и выполнения JS-скрипта
  while true; do
    mongo admin --eval "$js" && break
    mongo admin $auth --eval "$js" && break
    sleep 5
  done
) &
# Завершение основного процесса
exit 0