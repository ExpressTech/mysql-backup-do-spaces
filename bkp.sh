#!/bin/sh

# Structure copied from: https://github.com/woxxy/MySQL-backup-to-Amazon-S3
# Under a MIT license

# change these variables to what you need
MYSQLROOT=root
MYSQLPASS=
# name of your bucket on DO (without the sgp1.digitaloceanspaces.com)
DONAME=bkp-bucket
# the following line prefixes the backups with the defined directory. it must be blank or end with a /
DOPATH=production.app01/
# prefix of all backup file names
FILENAME=mysql-backup
# name of the database to be backed up or --all-databases
DATABASE='--all-databases'
# when running via cron, the PATHs MIGHT be different. If you have a custom/manual MYSQL install, you should set this manually like MYSQLDUMPPATH=/usr/local/mysql/bin/
MYSQLDUMPPATH=/usr/local/mysql/bin/
#tmp path.
TMP_PATH=/tmp/
#set the expiry days for complete bucket 
EXPIRY_DAYS=30

DATESTAMP=$(date +".%m.%d.%Y.%H.%M.%S.%s")


echo "Checking if s3cmd is present in current directory"
if ! [ -d "./s3cmd" ]; then
    echo "s3cmd is not installed. Downloading it.."
    wget -q https://github.com/s3tools/s3cmd/archive/master.zip -O s3cmd.zip
    unzip -q s3cmd.zip
    rm s3cmd.zip
    mv s3cmd-master s3cmd
    cp .s3cfg.sample .s3cfg
    echo "Create an access key in DO > Account > API > Space access keys and paste the keys in .s3cfg file (in current directory)"
    exit 1
fi

echo "Starting backing up the database to a file..."

if ! [ -f ${MYSQLDUMPPATH}mysqldump ]; then
    echo "mysqldump doesnt exists"
fi

# dump all databases
${MYSQLDUMPPATH}mysqldump --quick --user=${MYSQLROOT} --password=${MYSQLPASS} ${DATABASE} > ${TMP_PATH}${FILENAME}.sql

echo "Done backing up the database to a file."
echo "Starting compression..."

tar czf ${TMP_PATH}${FILENAME}${DATESTAMP}.tar.gz ${TMP_PATH}${FILENAME}.sql

echo "Done compressing the backup file."

# upload all databases
echo "Uploading the new backup..."
./s3cmd/s3cmd --config .s3cfg put -f ${TMP_PATH}${FILENAME}${DATESTAMP}.tar.gz s3://${DONAME}/${DOPATH}
echo "New backup uploaded."

echo "setting expiry date on the bucket"
./s3cmd/s3cmd --config .s3cfg expire s3://${DONAME} --expiry-days ${EXPIRY_DAYS}

echo "Removing the cache files..."
# remove databases dump
rm ${TMP_PATH}${FILENAME}.sql
rm ${TMP_PATH}${FILENAME}${DATESTAMP}.tar.gz
echo "Files removed."
echo "All done."