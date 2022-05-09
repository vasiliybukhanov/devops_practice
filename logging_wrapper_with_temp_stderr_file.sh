#!/bin/bash

get_timestamp_iso() {
    date +"%Y-%m-%dT%H:%M:%S%:z"
}

timestamp=$(get_timestamp_iso)

original_script=$1
base_script_name=$(basename "$1")
shift

echo "$timestamp run: $original_script $*" >>"$base_script_name.stdout.log"

$original_script "$@" > >(tee -a "$base_script_name.stdout.log") 2> >(tee -a "$base_script_name.stderr.tmp" >&2)
return_value=$?
timestamp_end=$(get_timestamp_iso)

# if something was logged to stderr
if [ -s "$base_script_name.stderr.tmp" ]; then
    {
        echo "$timestamp run: $original_script $*"
        cat "$base_script_name.stderr.tmp"
        echo "$timestamp_end returned: $return_value"
    } >>"$base_script_name.stderr.log"
fi
rm -f "$base_script_name.stderr.tmp"

echo "$timestamp_end returned: $return_value" >>"$base_script_name.stdout.log"
exit $return_value
