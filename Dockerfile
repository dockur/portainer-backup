# syntax=docker/dockerfile:1

FROM --platform=$BUILDPLATFORM node:alpine AS builder

WORKDIR /portainer-backup

RUN mkdir -p /portainer-backup/src
COPY package.json /portainer-backup
COPY src/*.js /portainer-backup/src

ARG VERSION_ARG="0.0"
RUN sed -i "s/0.0.0-development/${VERSION_ARG}/" /portainer-backup/package.json
RUN apk update && apk add --no-cache tzdata

ARG TARGETPLATFORM
ENV NODE_ENV=production

RUN case ${TARGETPLATFORM} in \
         "linux/amd64")  NPM_ARCH="x64" ;; \
         "linux/arm64")  NPM_ARCH="arm64" ;; \
         "linux/arm"*)   NPM_ARCH="arm" ;; \
         *) exit 1 ;; \
    esac \
 && npm install --cpu=${NPM_ARCH} --os=linux --omit=dev
    
FROM node:alpine AS runner
ENV NODE_ENV=production

RUN apk add --no-cache tzdata && rm -rf /var/cache/apk/*

VOLUME "/backup"
WORKDIR /portainer-backup

COPY --from=builder /portainer-backup /portainer-backup

# DEFAULT ENV VARIABLE VALUES
ENV TZ="America/New_York" 
ENV PORTAINER_BACKUP_URL="http://portainer:9000"
ENV PORTAINER_BACKUP_TOKEN=""
ENV PORTAINER_BACKUP_DIRECTORY="/backup"
ENV PORTAINER_BACKUP_FILENAME="/portainer-backup.tar.gz"
ENV PORTAINER_BACKUP_OVERWRITE=false
ENV PORTAINER_BACKUP_CONCISE=false
ENV PORTAINER_BACKUP_DEBUG=false
ENV PORTAINER_BACKUP_DRYRUN=false
ENV PORTAINER_BACKUP_STACKS=false

# NODEJS RUNNING THIS APPLICATION IS THE ENTRYPOINT
ENTRYPOINT [ "/usr/local/bin/node", "/portainer-backup/src/index.js" ]

# DEFAULT COMMAND (if none provided)
CMD ["schedule"]
