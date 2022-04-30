#!/bin/bash

backup_dir=$1

destination_dir=$2

archive_file_name="$(hostname)-$(date +"%Y-%m-%dT%H:%M:%S%:z").tar.gz"

echo "backing up $backup_dir to $destination_dir/$archive_file_name"
echo

if [ ! -d "$destination_dir" ]
then
	echo "destination directory not found. creating it now"
	mkdir -p $destination_dir
	echo
fi

# archive files using tar
tar czf $destination_dir/$archive_file_name $backup_dir

echo
echo "backup finished"
