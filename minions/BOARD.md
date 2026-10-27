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
| lint.arch | | W-2026-0003: lint-arch targets for go-core + devicesvc. GO by Mario 2026-10-27 11:37; option A approved 13:19 (owner dev-lead, cto-193) | 🔄 | 2026-10-27 13:24 |
| lint.arch | contract.maps | #1340 (Closes #1339) @b5657902 ready for Mario's merge: devicesvc contract package + strict map; go-core 8 packages strict, cyclic core partial, cbanalytics excluded; LINT.md fixed. Code + test APPROVED, Copilot clean; Unit Tests red only on known #1332 | 👀 | 2026-10-27 14:36 |
| go-core.small-refactor | | W-2026-0006: easy go-core refactors, each sub task its own issue + PR. Added by Mario 2026-10-27 13:23 (owner dev-lead, cto-194) | 🔄 | 2026-10-27 13:24 |
| go-core.small-refactor | package.isolate | #1344 (Closes #1342) @d4614efe ready for Mario's merge: StandardPipeSource to model/providermodel (breaks model->provider), ctx drops fileutils, one-site helpers inlined; behaviour unchanged. Code + test APPROVED, Copilot clean; Unit Tests red only on known #1332 | 👀 | 2026-10-27 14:49 |
| go-core.small-refactor | funcs.merge | #1347 (Closes #1345) @bed929d6 ready for Mario's merge: ParseDateTime + 3 go-core-only forwarders deleted, 6 kept (outside callers). Code + test APPROVED, Copilot clean; Unit Tests red only on known #1332 | 👀 | 2026-10-27 16:07 |
| floci.finish | | W-2026-0007: new mariotoffia/floci:latest (Mario's floci PRs + current floci main). Update TEOS_GROUNDZERO_TASKS.md and unskip the teos tests it unlocks so most tests run locally. Added by Mario 2026-10-27 13:31 (owner dev-lead, cto-195) | 🔄 | 2026-10-27 13:35 |
| floci.finish | list.update | Redone against mariotoffia/floci:latest (main + all 104 Mario PRs): 17 gaps newly ticked incl. 44.7, 50.5, 16; 53 still open; unlock bullets, UNLOCKS.md, REMAINING.md; copied to Mario's Mac 14:01 | ✅ | 2026-10-27 14:01 |
| floci.finish | skips.unlock | #1343 (Closes #1341) @a77dae2c ready for Mario's merge: Floci skips unlocked. Code + test APPROVED, Copilot clean; SUR Floci 7/7; Unit Tests red only on known #1332. gobridge ECS service-test blocked by new Floci ECR TLS cert gap (on Mario's list) | 👀 | 2026-10-27 15:35 |

## Blocked on Mario
- None. Floci gap 50.5 (FG-7) is fixed in the new mariotoffia/floci:latest (ticked by list.update 14:01).
