#### MongoDB 2.6 Docker image

Build:
```sh
docker build -t 'cainpsycode/mongo' .
```

Usage: 
```sh
docker run -ti --rm -p 27017:27017 -v d:/mongodb/test:/data/db -e MONGO_ROOT_PASSWORD=qwerty -e MONGO_OPTIONS='--auth' cainpsycode/mongo
```

- You may skip MONGOD_OPTIONS or set your own.
- To use syslog, add [--syslog](http://docs.mongodb.org/manual/reference/program/mongod/#cmdoption--syslog) to MONGOD_OPTIONS.
- MONGO_ROOT_PASSWORD and `--auth` are optional. If set, the admin user will be `root/qwerty` with `admin/userAdminAnyDatabase` privilege assigned.
- `-ti  ... /sbin/my_init -- bash -l` is optional, only if you want to enter the container in-band, not through [ssh](https://github.com/phusion/baseimage-docker/#login-to-the-container-or-running-a-command-inside-it-via-ssh).

Connect:

    mongo localhost:27017/admin -u root -p qwerty

Make sure your host mongo util is 2.6.
The MongoDB binaries used are official build from mongodb.org, but they lack SSL connectivity.

[authentication]: http://docs.mongodb.org/manual/core/security-introduction/
[runit]: http://smarden.org/runit/
[sshd]: https://github.com/phusion/baseimage-docker#login-to-the-container-or-running-a-command-inside-it-via-ssh
