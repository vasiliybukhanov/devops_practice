#!/bin/bash

OUT=log/stdout.log
ERR=log/stderr.log

mkdir -p log

get_timestamp_iso() {
	date +"%Y-%m-%dT%H:%M:%S%:z"
}

add_ts() {
	while IFS= read -r line; do
		printf '%s %s\n' "$(get_timestamp_iso)" "$line"
	done
}

# all goes to stdout
#"$@" 2>&1 | add_ts

# all goes to file
#"$@" 2>&1 | add_ts >>$OUT

# stdout goes to OUT, stderr goes to ERR, all with timestamps
{ "$@" 2>&1 1>&3 3>&- | add_ts | tee -a $ERR; } 3>&1 1>&2 | add_ts | tee -a $OUT
