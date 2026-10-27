#!/usr/bin/env bash
# Runs cache-gc.sh every 15 min. Pidfile keeps a single loop.
D=/workspace/minions/box-hygiene; P=$D/cache-gc-loop.pid
if [ -f "$P" ] && kill -0 "$(cat "$P")" 2>/dev/null; then echo "already running pid $(cat "$P")"; exit 0; fi
echo $$ >"$P"
while :; do "$D/cache-gc.sh"; sleep 300; done
