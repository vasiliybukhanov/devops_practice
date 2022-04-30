#!/bin/bash

timestamp=`date +"%Y-%m-%dT%H:%M:%S%:z"`

original_script=$1
base_script_name=$(basename $1)
shift

echo "$timestamp run: $original_script $@" >> $base_script_name.stdout.log

$original_script "$@" > >(tee -a $base_script_name.stdout.log) 2> >(tee -a $base_script_name.stderr.tmp >&2)
return_value=$?
timestamp_end=`date +"%Y-%m-%dT%H:%M:%S%:z"`

# if something was logged to stderr
if [ -s $base_script_name.stderr.tmp ]
then
    echo "$timestamp run: $original_script $@" >> $base_script_name.stderr.log
    cat $base_script_name.stderr.tmp  >> $base_script_name.stderr.log
    echo "$timestamp_end returned: $return_value" >>$base_script_name.stderr.log
fi
rm  -f "$base_script_name.stderr.tmp"

echo "$timestamp_end retured: $return_value" >>$base_script_name.stdout.log
exit $return_value
