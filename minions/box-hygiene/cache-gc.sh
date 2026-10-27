#!/usr/bin/env bash
# One pass: as box, if root-FS inode use >= THRESH%, clear ONLY the box Go build cache and golangci-lint cache.
# No sudo, no docker, no modcache, no /tmp, no worktrees.
set -u
D=/workspace/minions/box-hygiene; LOG=$D/cache-gc.log; THRESH=${THRESH:-80}
[ "$(id -un)" = box ] || { echo "$(date -Iseconds) refuse: not box" >>"$LOG"; exit 1; }
[ -e "$D/DISABLED" ] && exit 0
exec 9>"$D/.cache-gc.lock"; flock -n 9 || { echo "$(date -Iseconds) skip: already running" >>"$LOG"; exit 0; }
pct(){ df -i / | awk 'NR==2{gsub("%","",$5); print $5}'; }
b=$(pct)
if [ "$b" -lt "$THRESH" ]; then echo "$(date -Iseconds) check: ${b}% < ${THRESH}%, no action" >>"$LOG"; exit 0; fi
if [ -d /home/box/.cache/act/teos.lock ] && [ "$b" -lt 92 ]; then echo "$(date -Iseconds) defer: ${b}% but act job running (~/.cache/act/teos.lock), waits unless >=92%" >>"$LOG"; exit 0; fi
if pgrep -u box -x "go|golangci-lint" >/dev/null && [ "$b" -lt 92 ]; then echo "$(date -Iseconds) defer: ${b}% but a go/golangci-lint process is running, waits unless >=92%" >>"$LOG"; exit 0; fi
export PATH="/home/box/.local/bin:/home/box/go/bin:/usr/local/go/bin:$PATH" HOME=/home/box
g=ok; go clean -cache >/dev/null 2>&1 || g="partial(concurrent build?)"
l=ok; if command -v golangci-lint >/dev/null; then golangci-lint cache clean >/dev/null 2>&1 || l=fail; else l=missing; fi
echo "$(date -Iseconds) CLEAN: before=${b}% after=$(pct)% go-build=$g golangci-lint=$l" >>"$LOG"
