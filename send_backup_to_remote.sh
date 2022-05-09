#!/bin/bash

folder_to_copy=$1
remote_host_path=$2

rsync -ar "$folder_to_copy" "$remote_host_path"
