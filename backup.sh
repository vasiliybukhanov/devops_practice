#!/bin/bash

backup_files="/etc"

low_level_dir_name="hourly"

if [[ $1 == "-daily" ]]
then
	low_level_dir_name="daily"
fi

dest="${BACKUP_HOME:-"/srv/backups"}/${low_level_dir_name}"

archive_file_name="$(hostname)-$(date +%F_%T).tar.gz"

echo "backing up files to $dest/$archive_file_name"
date
echo

if [ ! -d "$dest" ]
then
	echo "destination directory not found. creating it now"
	mkdir -p $dest
	echo
fi

# archive files using tar
tar czf $dest/$archive_file_name $backup_files

echo
echo "backup finished"
date

#ls -lh $dest

