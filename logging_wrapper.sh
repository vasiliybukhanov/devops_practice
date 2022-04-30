#!/bin/bash

get_timestamp_iso() {
	echo $(date +"%Y-%m-%dT%H:%M:%S%:z")
}

timestamp=$(get_timestamp_iso)

logs_location=$1
shift

original_script=$1
base_script_name=$(basename $1)
out_log=$logs_location/$base_script_name.stdout.log
err_log=$logs_location/$base_script_name.stderr.log
shift

echo "$timestamp run: $original_script $@" >> $out_log

error_output=$($original_script "$@" 2>&1 >> $out_log)
return_value=$?
timestamp_end=$(get_timestamp_iso)

# if something was logged to stderr
if [ -n "$error_output" ]
then
	echo "$timestamp run: $original_script $@" >> $err_log
	echo "$error_output" >> $err_log
	echo "$timestamp_end returned: $return_value" >> $err_log
fi

echo "$timestamp_end retured: $return_value" >> $out_log
exit $return_value
