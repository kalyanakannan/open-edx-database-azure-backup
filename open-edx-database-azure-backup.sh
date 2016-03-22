cd /path/databasebackup
#create dirctory.and named as current date and time 
DIR_NAME=$(date +%Y%m%d%H%M%S)
sudo mkdir $DIR_NAME

#mongo backup
cd /path/databasebackup/$DIR_NAME
mongodump -o ./mongo-backup-$DIR_NAME

#mysql backup
export PGPASSWORD=

mysqldump -u root --all-databases > ./mysql-backup-$DIR_NAME.sql

cd /path/databasebackup
#change mode

sudo chmod 777 $DIR_NAME/mongo-backup-$DIR_NAME
sudo chmod 777 $DIR_NAME/mysql-backup-$DIR_NAME.sql

#make zip file

sudo zip -r $DIR_NAME/mongo-backup-$DIR_NAME.zip $DIR_NAME/mongo-backup-$DIR_NAME


export AZURE_STORAGE_ACCOUNT='your storage account name here'
export AZURE_STORAGE_ACCESS_KEY='your storage account key here'

export container_name=$DIR_NAME

export AZURE_MONGO_BLOB_NAME=mongo-backup-$DIR_NAME.zip
export AZURE_MYSQL_BLOB_NAME=mysql-backup-$DIR_NAME.sql

export image_mongo=$DIR_NAME/mongo-backup-$DIR_NAME.zip
export image_mysql=$DIR_NAME/mysql-backup-$DIR_NAME.sql

#creating container
echo "Creating the container..."
azure storage container create $container_name


echo "Uploading the image..."
azure storage blob upload $image_mongo $container_name $AZURE_MONGO_BLOB_NAME
azure storage blob upload $image_mysql $container_name $AZURE_mysql_BLOB_NAME

# remove 5 days older file is azure storage account and local machine

cd /path/databasebackup/
for Dir_name in `find -maxdepth 1 -type d -mtime +5`
do
   azure storage container delete -q `basename "$Dir_name"`
   sudo rm -rf `basename "$Dir_name"`
   echo `basename "$Dir_name"`
done


