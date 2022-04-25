#!/bin/bash

get_file_age_in_hours() {
	local seconds_since_epoch=$(date +%s)
	local file_last_modified=$(stat -L --format %Y $1)
	local file_age_in_seconds=$(($seconds_since_epoch - $file_last_modified))
	echo $(($file_age_in_seconds / 60 / 60))
}

get_file_hash_sum() {
	echo $(sha256sum $1 | awk '{print $1}')
}

backups_dir=${BACKUP_HOME:-"/srv/backups"}

for dir in $backups_dir/*
do
	for backup_file in $dir/*
	do
		# check if file is more than 2 days old
		if [[ $(get_file_age_in_hours $backup_file) < 24 ]]
		then
			continue
		fi

		#check if file with the same name on remote has the same hash sum		
		path_to_file_on_remote=$(ssh osboxes@10.0.2.4 find -name $(basename $backup_file))
		if [[ -z $path_to_file_on_remote ]]
		then
			continue
		fi

		local_file_sum=$(get_file_hash_sum $backup_file)
		remote_file_sum=$(ssh osboxes@10.0.2.4 "$(typeset -f get_file_hash_sum); get_file_hash_sum $path_to_file_on_remote")
		if [[ $local_file_sum == $remote_file_sum ]]
		then
			rm -f $backup_file
		fi
	done
done
