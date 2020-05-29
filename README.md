# postgresql-simple-backup

Simple backup strategy for PostgreSQL, useful for simple installations or non-critical systems.

`postgresql-simple-backup` is a Docker container which can run
once, or loop internally, doing backups of selected database
on a target host.

# Configuration

Any defaults are shown, but check `run.sh` just to make sure they are in sync.

All configuration parameters are provided via environment variables.

## Connection

These connection parameters must be defined.  All databases backed up will share this common configuration.

```sh
PGHOST=
PGPORT=5432
PGUSER=
PGPASSWORD=
```

## Databases

A space-separated list of databases to back up.

```sh
DATABASES=
```

## Cleanup

Age, in days, when older backups will be removed.  If empty, no
expiring will happen.

```sh
BACKUP_EXPIRE_DAYS=14
```

If defined as an empty string, it will disable expiration.

## Destination

Location where backups will be written.  This should be a volume mount.

```sh
BACKUP_DESTINATION=/backups
```

## Schedule

Back up pause.  This specifies the delay between current backup ending to the time
the next one is started.

```sh
BACKUP_FREQUENCY=3600
```

If defined as an empty string, the container will exit once a single backup run is performed.
