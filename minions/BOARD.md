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
| teos.test.integration.coverage | | W-2026-0009: find missing integration tests runnable locally on Floci; sub tasks added as identified. Added by Mario 2026-11-01 14:44 (owner dev-lead, cto-204). GO by Mario 2026-11-01 22:39 (t140u): all rows except alarm-service (not ready for testing); flow-gap sweep of existing service-tests (investigation only, new rows need Mario approval). eventsvc.buildingtracker.sqs.integration #1410 merged 2026-11-02 15:07 | 🔄 | 2026-11-02 15:10 |
| teos.test.e2e.coverage | | W-2026-0010: find missing e2e tests runnable locally on Floci; sub tasks added as identified. Added by Mario 2026-11-01 14:44 (owner dev-lead, cto-204). GO by Mario 2026-11-01 22:39 (t140u): all rows except alarm-service (not ready for testing); flow-gap sweep of existing service-tests (investigation only, new rows need Mario approval). eventsvc.service-test #1414 merged 2026-11-02 15:40 | 🔄 | 2026-11-02 15:40 |

## Blocked on Mario
- teos.test.integration.coverage + teos.test.e2e.coverage: approve or reject the 11 new test rows in work/W-2026-0009-test-coverage/flow-gaps.md (nothing goes on the board without yes).
- arch.guard (W-2026-0005): still waiting for your go (not on the board).
