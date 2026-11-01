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
| go-core.small-refactor | package.isolate | #1344 (Closes #1342) @d4614efe ready for Mario's merge: StandardPipeSource to model/providermodel (breaks model->provider), ctx drops fileutils, one-site helpers inlined; behaviour unchanged. Code + test APPROVED, Copilot clean; Unit Tests red only on known #1332; QA adversarial GO (qa-123) | 👀 | 2026-11-01 10:10 |
| go-core.small-refactor | funcs.merge | #1347 (Closes #1345) @cac54b8d: Mario merged main and kept the RandomStringAZ forwarder (eventsvc caller) 11-01 07:44-08:03; Copilot clean, 0 open threads; all checks green incl. Unit Tests. QA adversarial delta GO (qa-123). Waiting on Mario's merge | 👀 | 2026-11-01 10:10 |
| floci.unskip | | W-2026-0008: unskip every teos test that can run on mariotoffia/floci:latest; new Floci gaps go to TEOS_GROUNDZERO_TASKS.md; no tests that test Floci itself. GO by Mario 2026-11-01 14:44 (owner dev-lead, cto-204). 27.18/.19/.26/.28/.30/.31/.33 were already on main via #1343; leftover sweep #1394 (Closes #1393, adds 27.26 tklocal offline-status unskip) MERGED by Mario 20:45 @98c8c9b4. Lambda recursion gap is Mario's existing 53.1 (Floci) + 27.35 (teos). Only 27.9 (#1397) left | 🔄 | 2026-11-01 21:08 |
| floci.unskip | 27.9 | Prove retained data survives a local stack delete (M); #1397 withdrawn from merge-ready 20:48 per Mario ("delete if it only tests Floci"). Test-reviewer verdict: mixed, keep trimmed. golang-pro trimmed the Floci-only asserts @e1b3dafc 20:52 (keeps TEOS RunCloudUndeploy retain-hint/retry asserts), gates + Floci retain rc=0; test delta re-review APPROVED 20:53. PR is draft, CI running; next: ready, Copilot loop | 🔄 | 2026-11-01 21:08 |
| floci.unskip | 27.18 | Run the thing update test on Floci (S). Already on main via #1343 (cae376e3), found by golang-pro 14:51 | ✅ | 2026-11-01 15:26 |
| floci.unskip | 27.19 | Run the Logs missing group and stream tests on Floci (S). Already on main via #1343 (cae376e3), found by golang-pro 14:51 | ✅ | 2026-11-01 15:26 |
| floci.unskip | 27.26 | Run the tklocal presence test on Floci (S). Already on main via #1343 (cae376e3), found by golang-pro 14:51 | ✅ | 2026-11-01 15:26 |
| floci.unskip | 27.28 | Bind test API keys to usage plans on Floci (S); urgent: image now refuses unbound local API keys. Already on main via #1343 (cae376e3), found by golang-pro 14:51 | ✅ | 2026-11-01 15:26 |
| floci.unskip | 27.30 | Expect 401 for a missing scope on Floci (S). Already on main via #1343 (cae376e3), found by golang-pro 14:51 | ✅ | 2026-11-01 15:26 |
| floci.unskip | 27.31 | Run the MQTT outbound tests on Floci (S). Already on main via #1343 (cae376e3), found by golang-pro 14:51 | ✅ | 2026-11-01 15:26 |
| floci.unskip | 27.33 | Route IAM catalog row requests through API Gateway on Floci (S). Already on main via #1343 (cae376e3), found by golang-pro 14:51 | ✅ | 2026-11-01 15:26 |
| teos.test.integration.coverage | | W-2026-0009: find missing integration tests runnable locally on Floci; sub tasks added as identified. Added by Mario 2026-11-01 14:44 (owner dev-lead, cto-204) | 🔄 | 2026-11-01 14:46 |
| teos.test.integration.coverage | alarm.repo.dsql.integration | DSQL migrations on Floci, then alarm_repo create/get/page and history_repo append/list; first fix teos dsql.go BeforeConnect to send an IAM token (M). Proposal: work/W-2026-0009-test-coverage/proposal.md | ⏳ | 2026-11-01 14:50 |
| teos.test.integration.coverage | alarm.eventpublisher.eventbridge.integration | Oversized and >10-entry batches to a Floci EventBridge bus with an SQS target; each event arrives once (S). Proposal: work/W-2026-0009-test-coverage/proposal.md | ⏳ | 2026-11-01 14:50 |
| teos.test.integration.coverage | eventsvc.buildingtracker.sqs.integration | Building event on Floci SQS, run Serve(), diff reaches an httptest webhook (S). Proposal: work/W-2026-0009-test-coverage/proposal.md | ⏳ | 2026-11-01 14:50 |
| teos.test.e2e.coverage | | W-2026-0010: find missing e2e tests runnable locally on Floci; sub tasks added as identified. Added by Mario 2026-11-01 14:44 (owner dev-lead, cto-204) | 🔄 | 2026-11-01 14:46 |
| teos.test.e2e.coverage | alarm.service-test | Fill the empty alarm service-test: deploy, POST/GET alarm + alarm type, undeploy; needs the dsql.go IAM-token fix (L). Proposal: work/W-2026-0009-test-coverage/proposal.md | ⏳ | 2026-11-01 14:50 |
| teos.test.e2e.coverage | eventsvc.service-test | Deploy, send one building event, webhook mock receives it (M). Proposal: work/W-2026-0009-test-coverage/proposal.md | ⏳ | 2026-11-01 14:50 |
| teos.test.e2e.coverage | appstore.service-test | Deploy, catalog-api list, policies-api get, undeploy (L). Proposal: work/W-2026-0009-test-coverage/proposal.md | ⏳ | 2026-11-01 14:50 |

## Blocked on Mario
- go-core.small-refactor: Mario's merge of #1344 and #1347.
- floci.unskip: #1394 merged; #1397 (27.9) in rework (trimmed, re-reviewed, CI running), not yet back for merge.
