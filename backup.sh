#!/usr/bin/env bash
# Sync Mario's box state into this repo; commit+push only if changed.
set -euo pipefail
R="$(cd "$(dirname "$0")" && pwd)"; cd "$R"
EX=(--exclude='.env*' --exclude='*.pem' --exclude='*.key' --exclude='id_rsa*' --exclude='.git/' --exclude='credentials*')
mkdir -p minions thiink buzz skills
rsync -a --delete "${EX[@]}" --exclude='/work/' --exclude='/inbox/' /workspace/minions/ minions/
tar -C /workspace/minions -czf minions-work-inbox.tgz work inbox
if [ $(stat -c%s minions-work-inbox.tgz) -gt 52428800 ]; then rm minions-work-inbox.tgz; echo "archive >50MB, skipped"; fi
rsync -a /workspace/thiink/{design_minion_collaboration.md,skills_inventory.md,create_list.json} /workspace/thiink/report_*.md thiink/
rsync -a /workspace/buzz/state.json buzz/
rsync -a --delete "${EX[@]}" /home/box/agent-data/workflows/ skills/
# secret scan
if rg -n --hidden -g '!.git' -g '!backup.sh' -e 'AKIA[0-9A-Z]{16}' -e 'gh[pousr]_[A-Za-z0-9]{30,}' -e 'xox[bpas]-[A-Za-z0-9-]{10,}' -e 'BEGIN [A-Z ]*PRIVATE KEY' -e '(token|password|secret)\s*[=:]\s*["'"'"']?[A-Za-z0-9/+_-]{16,}' . ; then
  echo "SECRET SCAN HIT - aborting"; exit 1; fi
[ "${NO_PUSH:-}" = 1 ] && exit 0
git add -A
git diff --cached --quiet && { echo "no changes"; exit 0; }
git commit -qm "backup: $(date '+%F %T %Z')" && git push -q origin HEAD:main
