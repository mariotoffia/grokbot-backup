# box-hygiene: cache-gc (owner: platform-lead minion)

Keeps the box root FS from running out of inodes by clearing **only** regenerable box caches:
`~/.cache/go-build` (`go clean -cache`) and the golangci-lint cache (`golangci-lint cache clean`).
Runs as `box`, never sudo, never docker, never the Go modcache, /tmp, or worktrees.

- Checks every 5 min; acts only when `df -i /` use is **>= 80%** (override: `THRESH=90`).
- `flock` on `.cache-gc.lock` means it never runs twice at once; pidfile keeps one loop.
- Log: `/workspace/minions/box-hygiene/cache-gc.log` (time, % before/after, per-cache result).
- Defers while any box `go` or `golangci-lint` process runs (unless >= 92%), so it never wipes the shared cache mid-build.
- Defers while an act job holds `~/.cache/act/teos.lock` unless use is >= 92%, so it does not clear caches under a live act-lint/act-test run. A "partial" go-build result in the log flags a concurrent build; report breakage to platform-lead/dev-lead.

## Start / stop
- Start (idempotent, also after a box restart, since there is no cron/systemd): `/workspace/minions/box-hygiene/start.sh`
- Pause without stopping: `touch /workspace/minions/box-hygiene/DISABLED` (resume: `rm` it)
- Stop: `kill $(cat /workspace/minions/box-hygiene/cache-gc-loop.pid)`
- One-off manual run: `/workspace/minions/box-hygiene/cache-gc.sh`

## box-env apt status (parked, cto-215, 2026-11-03)
- `box-env-restore.sh` exits rc=100 at apt-tools: `apt-get update` gets "500 Internal Server Error [IP: 198.18.0.1 80]" from the egress proxy for deb.debian.org (trixie, trixie-updates, trixie-security). Plain curl to the same host returns 200.
- Missing (parked): build-essential, zip, git-lfs, zsh, lsof, upx-ucl, nsis, asciidoctor, restic. Present: make 4.4.1, gcc, aws CLI v2, docker, binfmt arm64.
- CTO decision: no retry, no routine, no fallback. Install a package only when a work item needs it. If apt still returns 500 then, ring the CTO blocked with the exact package list.
- Known glitch: the floci-pull step prints "template parsing error: unclosed action" (harmless).
