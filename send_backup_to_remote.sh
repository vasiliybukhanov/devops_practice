#!/bin/bash

rsync -ar ${BACKUP_HOME:-"/srv/backups"} osboxes@10.0.2.4:~/
