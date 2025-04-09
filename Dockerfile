FROM debian:bullseye-slim

ARG MONGO_VERSION=2.6.7 \
    MONGO_URL=https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-${MONGO_VERSION}.tgz

# Environment variables
ENV MONGO_DATA=/data/db \
    MONGO_LOG=/var/log/mongod.log \
    MONGO_OPTIONS=--auth

# Install dependencies, download MongoDB and cleanup in single layer
RUN set -ex; \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        tar \
        gnupg; \
    # Create mongo user and directories
    groupadd -r mongo && \
    useradd -r -g mongo -s /usr/sbin/nologin mongo && \
    mkdir -p ${MONGO_DATA} && \
    mkdir -p /var/log && \
    chown -R mongo:mongo ${MONGO_DATA} /var/log; \
    # Download and install MongoDB
    curl -L ${MONGO_URL} -o /tmp/mongodb.tgz && \
    mkdir -p /tmp/mongodb && \
    tar -xzf /tmp/mongodb.tgz -C /tmp/mongodb --strip-components=1 && \
    cp /tmp/mongodb/bin/* /usr/local/bin/ && \
    chmod +x /usr/local/bin/* && \
    # Cleanup
    rm -rf /tmp/mongodb /tmp/mongodb.tgz && \
    apt-get purge -y --auto-remove curl gnupg && \
    rm -rf /var/lib/apt/lists/*

# Copy entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Healthcheck to verify MongoDB is running
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD mongo --eval 'db.runCommand("ping").ok' || exit 1

# Runtime configuration
USER mongo
WORKDIR ${MONGO_DATA}
VOLUME ${MONGO_DATA}
EXPOSE 27017

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
