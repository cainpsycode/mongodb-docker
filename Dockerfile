FROM  alpine:3.14
RUN apk add --update \
    curl \
    tar \
    && rm -rf /var/cache/apk/*
RUN curl -sS https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.6.7.tgz \
        | tar xz --no-same-owner -C /usr/local --strip-components 1 --wildcards -f - \*/bin/\* \
    && mkdir -p /etc/service/mongod \
    && addgroup --system mongodb \
    && adduser --system -g mongodb mongodb
ADD mongod.sh /etc/service/mongod/run
ADD mongo-admin.sh /etc/my_init.d/90_mongo-admin.sh
RUN rm -f /etc/service/sshd/down
VOLUME /data/db
EXPOSE 22 27017
