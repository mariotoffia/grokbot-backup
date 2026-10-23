#!/usr/bin/env bash
set -euo pipefail
B=/tmp/grokbot-backup; [ -d $B ] || gh repo clone mariotoffia/grokbot-backup $B
mkdir -p /workspace/minions /workspace/thiink/minions /workspace/buzz /home/box/agent-data/workflows /workspace/repos
rsync -a $B/minions/ /workspace/minions/
[ -f $B/minions-work-inbox.tgz ] && tar -C /workspace/minions -xzf $B/minions-work-inbox.tgz
rsync -a --delete /workspace/minions/ /workspace/thiink/minions/   # byte-identical mirror
rsync -a $B/thiink/ /workspace/thiink/
cp $B/buzz/state.json /workspace/buzz/
rsync -a $B/skills/ /home/box/agent-data/workflows/
[ -d /workspace/repos/teos ] || gh repo clone Thiink-LLC/teos /workspace/repos/teos
[ -d /workspace/repos/floci ] || gh repo clone mariotoffia/floci /workspace/repos/floci
cd /workspace/repos/teos
S=$(git ls-files | grep -m1 'machine-setup.sh$' || true)
if [ -z "$S" ]; then gh pr checkout 1248 && S=$(git ls-files | grep -m1 'machine-setup.sh$'); fi
bash "$S"
echo ">>> Now sign in again via device codes: gh auth login, aws sso login, Slack/Gmail/etc."
