#!/bin/bash

# Recovery script:
# * Calls wal-g to recover the latest database
# * Configures postgres to enter recovery mode by:
# * 1. Setting signal
# * 2. Appending wal-g recovery commands onto postgresql.conf
# * 3. Configuring postgres to only allow connections from localhost, preventing concurrent updates
# * 4. Disabling archive mode so as not to corrupt S3 backups
# * Starts postgres
#
# If you get an error message, DON'T PANIC! Just read the message and do what it tells you to do.

[ -z ${AWS_ACCESS_KEY_ID+x} ] && VARS="$VARS AWS_ACCESS_KEY_ID"
[ -z ${AWS_SECRET_ACCESS_KEY+x} ] && VARS="$VARS AWS_SECRET_ACCESS_KEY"
[ -z ${AWS_ENDPOINT+x} ] && VARS="$VARS AWS_ENDPOINT"
[ -z ${AWS_REGION+x} ] && VARS="$VARS AWS_REGION"
[ -z ${WALG_S3_PREFIX+x} ] && VARS="$VARS WALG_S3_PREFIX"
[ -z ${WALG_LIBSODIUM_KEY+x} ] && VARS="$VARS WALG_LIBSODIUM_KEY"

if [ ! -z "$VARS" ]; then
  echo "The following enviornment variables must be set:$VARS"
  exit 1
fi

if [ $(id -u) == "0" ]; then
  echo "this command must be run as the postgres user (\`su postgres\`)."
  exit 1
fi

set -euo pipefail

if [ -z ${PGDATA+x} ]; then
  echo "Setting PGDATA to /var/lib/postgresql/data/pgsql"
  export PGDATA=/var/lib/postgresql/data/pgsql
fi

# fetch most recent full backup
wal-g backup-fetch $PGDATA LATEST

# enable recovery mode, disable remote connections and archive mode
touch $PGDATA/recovery.signal
cp $PGDATA/postgresql.conf $PGDATA/postgresql.conf.orig
cat /wal-g/recovery.conf >>$PGDATA/postgresql.conf
mv $PGDATA/pg_hba.conf $PGDATA/pg_hba.conf.orig
cp /wal-g/pg_hba.conf $PGDATA/pg_hba.conf
sed -i -e 's/^archive_mode = on/archive_mode = off/' $PGDATA/postgresql.conf

PG_VERSION=$(ls /usr/lib/postgresql/)

/usr/lib/postgresql/$PG_VERSION/bin/pg_ctl start -D $PGDATA

echo "Recovery complete. Press <return> to continue."
echo "If this is a production recovery, simply restart the container."
echo ""
echo "To test the database, disable \`archive_mode\` in $PGDATA/postgresql.conf or you risk "
echo "corrupting backups of the production instance. Then run \`postgres start\` to start the instance in test mode."
