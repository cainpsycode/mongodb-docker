FROM debian:bullseye-slim

ENV MONGO_VERSION=2.6.7
ENV MONGO_URL=https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-${MONGO_VERSION}.tgz

# Установка зависимостей
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    tar \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Создание пользователя
RUN groupadd -r mongo && useradd -r -g mongo -s /usr/sbin/nologin mongo

# Скачивание и установка MongoDB
RUN curl -L $MONGO_URL -o /tmp/mongodb.tgz && \
    mkdir -p /tmp/mongodb && \
    tar -xzf /tmp/mongodb.tgz -C /tmp/mongodb --strip-components=1 && \
    cp /tmp/mongodb/bin/* /usr/local/bin/ && \
    chmod +x /usr/local/bin/* && \
    rm -rf /tmp/mongodb /tmp/mongodb.tgz

# Копируем entrypoint-скрипт
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Создаём каталог для данных
RUN mkdir -p /data/db && chown -R mongo:mongo /data/db
RUN mkdir -p /var/log && chown mongo:mongo /var/log
USER mongo
WORKDIR /data/db

EXPOSE 22 27017

# Выполнение entrypoint с передачей окружения
CMD ["sh"]
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
