# Backup MySQL Databases to Digital Ocean Spaces

Digitalocean spaces are cheap ($5/mo for 250 GB!). 

This script will back your database(s) to DO spaces with easiest way possible. 

## How to use
1. Git clone the directory
2. Copy .s3cfg.sample to .s3cfg and enter your DO access key and secret along with your destination geo. 
3. Change the variables in bkp.sh tool to match your env.
4. Run ./bkp.sh
5. It will download the s3cmd tool. 
6. Uploads the mysql backup to your bucket in a folder specified by you. 


