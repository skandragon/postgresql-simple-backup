FROM alpine:3.11
MAINTAINER explorer@flame.org

# The host, user, and password to use.  All databases backed up
# will share this common configuration.
ENV PGHOST=
ENV PGPORT=5432
ENV PGUSER=
ENV PGPASSWORD=

# A space-separated list of databases to back up.
ENV DATABASES=

# Age, in days, when older backups will be removed.  If empty, no
# expiring will happen.
ENV BACKUP_EXPIRE_DAYS=14

# Location where backups will be written.
# This is typically a volume...
ENV BACKUP_DESTINATION=/backups

# Back up pause.  This is measured from the time the backup starts to the time
# the next one is completed.
ENV BACKUP_FREQUENCY=3600

# Don't change anything below here.
ENV WORKDIR=/container
ENV CONTAINER_UID=1000
ENV CONTAINER_GID=1000
ENV CONTAINER_USERNAME=skandragon

RUN \
  addgroup -g $CONTAINER_GID -S $CONTAINER_USERNAME \
  && adduser --home ${WORKDIR} --shell /bin/sh --disabled-password --no-create-home --gecos 'Skandragon' -G $CONTAINER_USERNAME --uid $CONTAINER_UID $CONTAINER_USERNAME

RUN apk update \
  && apk add --no-cache postgresql-client \
  && rm -rf /var/cache/apk/*

RUN mkdir ${BACKUP_DESTINATION} && chown ${CONTAINER_UID}:${CONTAINER_GID} ${BACKUP_DESTINATION}

RUN mkdir ${WORKDIR} && chown ${CONTAINER_UID}:${CONTAINER_GID} ${WORKDIR}
WORKDIR ${WORKDIR}

COPY entrypoint.sh /entrypoint.sh
COPY run.sh /run.sh
RUN chmod +x /*.sh

USER $CONTAINER_UID:$CONTAINER_GID

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/sh", "/run.sh"]
