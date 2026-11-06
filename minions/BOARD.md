# Minion board — work items

## Legend

✅ done (finished/merged) · 🔄 progress (work started) · 📐 designed (planned/designed, not implemented) · 👀 PR created, waiting for human review (internal reviews + Copilot clean, checks green, waiting on Mario) · ⏳ waiting (added, nothing done yet)

## How to update this board

- The owner coordinator updates the board on every status change.
- Each change sets Last updated to Stockholm time, `YYYY-MM-DD HH:MM`.
- One row per sub task, plus a parent row with the Sub task cell blank.
- Use only the five icons above.
- REQUIREMENT: update the row the moment a task changes state or makes progress (start, milestone, blocked, PR opened, ready for Mario, merged).
- New items start as ⏳.
- Purge: move ✅ rows (a parent only together with all its sub tasks, all ✅) to `done/<YYYY-MM-DD>.md`, dated by the Stockholm purge day, keeping row order. Same title style, Legend and table layout as this board; append to that day's file if it exists, else create it.
- Keep names short and unique, in dotted lowercase. Put the W-id in Description. Sub tasks from another list keep their remote id (e.g. `27.16.3`, `T1 os-detect`).

Details live in `work/<id>/STATUS.md`.

| Task | Sub task | Description | Status | Last updated |
|---|---|---|---|---|

## Blocked on Mario
- 2026-11-06 19:38: W-2026-0009 + W-2026-0010 MERGED by Mario t199u (all 8 PRs). Board purged. Cleanup done (rcm-1471 / Dev Lead 1473). Still waiting go: arch.guard (W-0005).

- arch.guard (W-2026-0005): still waiting for your go (not on the board).
- 39.21 ECR_TLS_URI one-liner and SUR 27.39 drop-skip were NOT boarded (Mario picked all-8 only).
