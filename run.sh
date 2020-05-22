#!/bin/sh

cd $BACKUP_DESTINATION

var_expand() {
  if [ -z "${1-}" ] || [ $# -ne 1 ]; then
    printf 'var_expand: expected one argument\n' >&2;
    return 1;
  fi
  eval printf '%s' "\"\${$1}\""
}

error=false
for var in PGUSER PGPASSWORD PGHOST DATABASES ; do
  eval "value=\${$var}"
  [ -z "${value}" ] && {
    echo "${var} not set"
    error=true
  }
done

[ "$error" = "true" ] && {
  echo "Exiting."
  exit 1
}

# Clean up old files
expire() {
  [ -s "$BACKUP_EXPIRE_DAYS"] && {
    echo "Removing any *.sql.gz files older than ${BACKUP_EXPIRE_DAYS} days."
    find . -type f -mtime +${BACKUP_EXPIRE_DAYS} -name '*.sql.gz' -execdir rm -- '{}' \;
  }
}

backup() {
  for database in $DATABASES ; do
    timestamp=`date +"%Y%m%d-%H%M%S"`
    filename="${database}.${timestamp}.sql.gz"
    echo "Backing up ${database} to ${filename}"
    pg_dump --dbname="${database}" | gzip > "${filename}"
  done
}

if [ -z "${BACKUP_FREQUENCY}" ] ; then
  echo "BACKUP_FREQUENCY not set, exiting after a single backup is performed."
  expire()
  backup()
else
  while true ; do
    expire()
    backup()
    echo "Backup run complated, sleeping for ${BACKUP_FREQUENCY} seconds."
    sleep $BACKUP_FREQUENCY
  done
fi
