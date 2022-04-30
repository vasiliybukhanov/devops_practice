#!/bin/bash

get_file_age_in_seconds_by_date() {
	echo $(date -d $1 +%s)
}

get_file_creation_date_from_name() {
	echo $(echo $1 | awk -F '.' '{start = index($1, "-"); print substr($1, start + 1)}')
}

get_file_hash_sum() {
	echo $(sha256sum $1 | awk '{print $1}')
}

remove_file_if_older_than_2_days() {
	local backup_file=$1
	# check if file is more than 2 days old
	local file_creation_date=$(get_file_creation_date_from_name $backup_file)
	local file_age_in_seconds=$(get_file_age_in_seconds_by_date $file_creation_date)
	local two_days_ago_in_seconds=$(date -d +'2 days ago' +%s)
	if [[ file_age_in_seconds > two_days_ago_in_seconds ]]
	then
		return	
	fi

	#check if file with the same name on remote has the same hash sum		
	local path_to_file_on_remote=$(ssh $remote_hostname find -name $(basename $backup_file))
	if [[ -z $path_to_file_on_remote ]]
	then
		return
	fi

	local local_file_sum=$(get_file_hash_sum $backup_file)
	local remote_file_sum=$(ssh $remote_hostname "$(typeset -f get_file_hash_sum); get_file_hash_sum $path_to_file_on_remote")
	if [[ $local_file_sum == $remote_file_sum ]]
	then
		rm -f $backup_file
	fi
}

backups_location_dir=$1
remote_hostname=$2

for element in $backups_location_dir/*
do
	if [[ -d $element ]]
	then
		for backup_file in $element/*
		do
			remove_file_if_older_than_2_days $backup_file
		done
	else
		remove_file_if_older_than_2_days $element
	fi
done
