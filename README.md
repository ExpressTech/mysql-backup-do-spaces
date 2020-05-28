# Backup MySQL Databases to Digital Ocean Spaces

Digitalocean spaces are cheap ($5/mo for 250 GB!). 

This script will back your database(s) to DO spaces with easiest way possible. 

## Requirements
```
apt-get install python python-dateutil unzip
```

## How to use
1. Git clone the directory
2. Change the variables in bkp.sh tool to match your env.
3. Run ./bkp.sh
4. It will download the s3cmd tool. 
5. Open .s3cfg and enter your DO access key and secret along with your destination geo. 
6. Run it again.
7. Uploads the mysql backup to your bucket in a folder specified by you. 


