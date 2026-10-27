#!/usr/bin/env bash
# Idempotent start (re-run after a box restart; there is no cron/systemd on the box).
D=/workspace/minions/box-hygiene
nohup setsid "$D/cache-gc-loop.sh" >>"$D/cache-gc-loop.out" 2>&1 < /dev/null &
sleep 1; cat "$D/cache-gc-loop.pid"
