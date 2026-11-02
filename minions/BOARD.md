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
| go-core.small-refactor | | W-2026-0006: easy go-core refactors, each sub task its own issue + PR. Added by Mario 2026-10-27 13:23 (owner dev-lead, cto-194) | 🔄 | 2026-10-27 13:24 |
| go-core.small-refactor | package.isolate | #1344 (Closes #1342) now @047c8990: main merged in 21:04 to clear the stale-base cbanalytics (#1332) red, local gates all pass. StandardPipeSource to model/providermodel (breaks model->provider), ctx drops fileutils, one-site helpers inlined; behaviour unchanged. Code + test APPROVED, Copilot clean, QA adversarial GO (qa-123); CI on new head: Static/Architecture/CodeQL green, Copilot 0 threads, Unit Tests/Build label-skipped (local race + Floci gates rc=0). Waiting on Mario's merge | 👀 | 2026-11-02 21:40 |
| go-core.small-refactor | funcs.merge | #1347 (Closes #1345) @cac54b8d: Mario merged main and kept the RandomStringAZ forwarder (eventsvc caller) 11-01 07:44-08:03; Copilot clean, 0 open threads; all checks green incl. Unit Tests. QA adversarial delta GO (qa-123). Waiting on Mario's merge | 👀 | 2026-11-01 10:10 |
| teos.test.integration.coverage | | W-2026-0009: find missing integration tests runnable locally on Floci; sub tasks added as identified. Added by Mario 2026-11-01 14:44 (owner dev-lead, cto-204). GO by Mario 2026-11-01 22:39 (t140u): all rows except alarm-service (not ready for testing); flow-gap sweep of existing service-tests (investigation only, new rows need Mario approval). eventsvc.buildingtracker.sqs.integration #1410 merged 2026-11-02 15:07 | 🔄 | 2026-11-02 15:10 |
| teos.test.e2e.coverage | | W-2026-0010: find missing e2e tests runnable locally on Floci; sub tasks added as identified. Added by Mario 2026-11-01 14:44 (owner dev-lead, cto-204). GO by Mario 2026-11-01 22:39 (t140u): all rows except alarm-service (not ready for testing); flow-gap sweep of existing service-tests (investigation only, new rows need Mario approval). eventsvc.service-test #1414 merged 2026-11-02 15:10 | 🔄 | 2026-11-02 15:40 |

## Blocked on Mario
- go-core.small-refactor: Mario's merge of #1344 and #1347.
