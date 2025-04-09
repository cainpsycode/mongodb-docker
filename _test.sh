#!/bin/sh -xe
tmp=$(mktemp -d)
docker run -ti --rm \
    -p 27017:27017 \
    -v $tmp:/data/db \
    -e MONGOD_OPTIONS='--nojournal --smallfiles --noprealloc --auth --syslog' \
    -e MONGO_ROOT_PASSWORD=qwerty \
    cainpsycode/mongodb
