FROM golang:1.25.3-alpine AS builder

ARG MIGRATE_VERSION=v4.19.1
ARG MIGRATE_OS=linux
ARG MIGRATE_ARCH=amd64

RUN apk add --no-cache curl && \
    curl -L "https://github.com/golang-migrate/migrate/releases/download/${MIGRATE_VERSION}/migrate.${MIGRATE_OS}-${MIGRATE_ARCH}.tar.gz" | tar -xvz

FROM golang:1.25.3-alpine

ARG MIGRATE_OS=linux
ARG MIGRATE_ARCH=amd64

RUN apk add --no-cache make

COPY --from=builder /go/migrate /usr/local/bin/migrate
