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
- Never delete done rows. Move them within the table instead; done rows stay in the table.
- Keep names short and unique, in dotted lowercase. Put the W-id in Description. Sub tasks from another list keep their remote id (e.g. `27.16.3`, `T1 os-detect`).

Details live in `work/<id>/STATUS.md`.

| Task | Sub task | Description | Status | Last updated |
|---|---|---|---|---|
| floci.groundzero | | W-2026-0001: Floci-only groundzero tasks W1–W4, owner dev-lead; box env OK (docker, make, arm64 aarch64); 👀 for Mario: #1250, #1248, #1257, #1260; #1252 @57708ced internal APPROVED, 1 open Copilot thread; #1255 @5124119e Copilot clean, test-delta fix 14aad90b on Floci run; #1242 @75c3be6b internal APPROVED, Copilot no open issues, dev-lead ready call | 🔄 | 2026-10-23 15:03 |
| floci.groundzero | 27.12 | Qualified ECR port range (#1212) | ✅ | 2026-10-22 11:07 |
| floci.groundzero | 27.14 | Local fleet indexing readiness (#1213) | ✅ | 2026-10-22 11:07 |
| floci.groundzero | 27.13 | Already on main; closed in #1213 | ✅ | 2026-10-22 11:07 |
| floci.groundzero | 27.25 | Log subscription test on Floci (#1214) | ✅ | 2026-10-22 11:09 |
| floci.groundzero | 27.10 | Collector uses real parameter change events (#1215) | ✅ | 2026-10-22 11:09 |
| floci.groundzero | 27.16.6 | eventsvc: no retry/DLQ test yet, comment only (#1228) | ✅ | 2026-10-22 13:16 |
| floci.groundzero | 27.21 | cbtarget shadow metadata timestamps (#1226) | ✅ | 2026-10-22 13:52 |
| floci.groundzero | 27.20 | Fleet index search tests on Floci (#1229) | ✅ | 2026-10-22 13:59 |
| floci.groundzero | 27.16.2 | Actuation shadow topic rule tests (#1227) | ✅ | 2026-10-22 14:34 |
| floci.groundzero | 27.16.3 | Corerouter shadow mirror tests on Floci (#1230) | ✅ | 2026-10-22 16:17 |
| floci.groundzero | 27.16.4 | FG-1 FIXED on floci:latest 07ced9c6; PR #1255 (Closes #1232) HEAD 14aad90b: Copilot r2 @5124119e approval recommended, 0 threads; code + clean-arch APPROVED @849de752, hex APPROVED_DEGRADED (until #1257 merges); code delta APPROVED @5124119e; fixes pushed 14aad90b (loop guard, page cap, transform filter, service-test logLevel trace; Floci -race rc=0); test APPROVED_DEGRADED @14aad90b; minors (trace logLevel out of docs tag region, exact count) -> golang-pro; code APPROVED @14aad90b (L1 extra unit cases folded in) | 🔄 | 2026-10-23 15:13 |
| floci.groundzero | 27.16.4a | ingestionsvc go-arch-lint map, PR #1257 (Closes #1256) HEAD 7139f4b8: code + hexagonal + Lead Architect APPROVED; marked ready, Copilot clean (0 comments) (golang-pro); LINT.md count restack needed if #1250 merges first | 👀 | 2026-10-23 12:59 |
| floci.groundzero | adr.0001 | umbrella ADR go-arch-lint map per service, PR #1260 (code + LA APPROVED @105a4eff; ready, Copilot CLEAN @3d8f6dea; code + LA APPROVED @392d8a7e; Copilot CLEAN @392d8a7e; merge-ready) (Closes #1259) at 392d8a7e (technical-writer): Lead Architect content check + code review | 👀 | 2026-10-23 13:10 |
| floci.groundzero | docs.ingestionsvc | follow-up issue #1258 ingestionsvc service docs (filed, Incoming, not started) | ⏳ | 2026-10-23 12:48 |
| floci.groundzero | 39.11 | W3: delete the 2 GoBridge skips (#1234) | ✅ | 2026-10-23 09:15 |
| floci.groundzero | 27.16.1 | W4: eventsvc ESM/alarm/runtime (#1240) | ✅ | 2026-10-23 09:18 |
| floci.groundzero | 27.1 | W4: APIGW v1 contract cases (#1242); Mario 10:41: drop x-amzn-ErrorType asserts + FG-7 skip; head 75c3be6b (retitled, comment fixes); gates green except pre-existing cmd/cblicense (#1245); code delta APPROVED @75c3be6b; test APPROVED_DEGRADED (no CI e2e); Copilot @75c3be6b no open issues, 0 threads ("needs a closer look" note on shared GroundZero setup); checks green; dev-lead call whether ready for Mario | 🔄 | 2026-10-23 15:03 |
| floci.groundzero | 27.27 | W4: remove Cognito CustomDomain workarounds (#1236) | ✅ | 2026-10-23 09:17 |
| floci.groundzero | 27.27a | buildingsvc go-arch-lint map, PR #1250 (Closes #1249) at 798b11c5: code + hexagonal APPROVED; Copilot clean; CI green; Lead Architect APPROVED as baseline condition MET (#1261 filed+linked); ON CONDITION: tracking issue (depOnAnyVendor true -> outbound ports) filed + linked in body -> golang-pro | 👀 | 2026-10-23 12:53 |
| floci.groundzero | machine.setup | Linux build box setup script (#1248): code + security APPROVED at f23dd485; Copilot CLEAN at head 36292726; code + security delta APPROVED @36292726 (lows -> #1252); merge-ready | 👀 | 2026-10-23 13:06 |
| floci.groundzero | machine.setup.arm64 | Follow-up #1252 (Closes #1251, arm64 binfmt; #1248 merged forward; IPv6 legacy docker rules + dnsmasq/DOCKER-USER v6 hardening -> release-config-mgr): head 57708ced, Build green; real run green; code + security delta APPROVED @57708ced; 1 open Copilot thread (14:40, machine-setup.sh recovery steps need a cbdeploy rerun) to fix (release-config-mgr) ; head 8cac9d1d (cbdeploy link warning fix), Copilot not responding; code delta APPROVED @8cac9d1d; one more Copilot request pending | 🔄 | 2026-10-23 15:14 |
| floci.groundzero | 27.29 | W4: un-skip SUR LogImport (#1238) | ✅ | 2026-10-23 09:17 |
| makefile.linux | | W-2026-0004: all teos make targets on Debian + macOS, OS logic isolated | 📐 | 2026-10-22 13:42 |
| makefile.linux | T1 os-detect | `make/os.mk` plus per-OS files | 📐 | 2026-10-22 13:14 |
| makefile.linux | T2 tool-path | GOBIN / npm bin on PATH | 📐 | 2026-10-22 13:14 |
| makefile.linux | T3 install | Robust Linux `make install` (apt retry, sudo, pins) | 📐 | 2026-10-22 13:14 |
| makefile.linux | T4 corepack | Writable COREPACK_HOME default | 📐 | 2026-10-22 13:14 |
| makefile.linux | T5 atomic-codegen | Non-destructive codegen for all generate targets | 📐 | 2026-10-22 13:18 |
| makefile.linux | T6 fail-propagate | Recursive aggregators propagate failures | 📐 | 2026-10-22 13:14 |
| makefile.linux | T7 portable-cmds | Replace GNU/BSD-only calls (sed, lsof, /tmp) | 📐 | 2026-10-22 13:14 |
| makefile.linux | T8 shell | bash with strict flags (or install zsh) | 📐 | 2026-10-22 13:14 |
| makefile.linux | T9 doctor | `make doctor` preflight | 📐 | 2026-10-22 13:14 |
| makefile.linux | T10 docs | Linux/macOS setup docs | 📐 | 2026-10-22 13:14 |
| makefile.linux | T11 ci-parity | CI on ubuntu + macos runners | 📐 | 2026-10-22 13:14 |
| makefile.linux | T12 review | Regression/security review | 📐 | 2026-10-22 13:14 |
| makefile.linux | T13 run-isolation | Per-run/per-worktree RUN_TMP + flock | 📐 | 2026-10-22 13:18 |
| makefile.linux | T14 cert-isolation | Harness CA cert with owner record | 📐 | 2026-10-22 13:18 |
| makefile.linux | T15 clean-temp | clean-temp keeps live owners' files | 📐 | 2026-10-22 13:18 |
| makefile.linux | T16 parallel-test | Parallel-run regression job | 📐 | 2026-10-22 13:18 |
| makefile.linux | T17 runner-locks | Batch runners honour worktree locks | 📐 | 2026-10-22 13:18 |
| hostarch.builds | | W-2026-0002: host-arch builds, arm64 for AWS; ≈3–4 days, needs ADR; after W-0001 | ⏳ | 2026-10-21 15:40 |
| lint.arch | | W-2026-0003: lint-arch targets for go-core + devicesvc | ⏳ | 2026-10-21 16:04 |

## Blocked on Mario

- makefile.linux (W-2026-0004): go for T1–T17 (requested 2026-10-22 13:42 in #teos-grokbot).
- hostarch.builds (W-2026-0002): go to start, after floci.groundzero is done (needs an ADR).
- lint.arch (W-2026-0003): go to start.
- floci.groundzero (W-2026-0001): merge #1250 (👀 12:53), #1248 (👀 13:06), #1260 (👀 13:10) and #1257 (👀 12:59; restack LINT.md to 12 if #1250 lands first).
- floci.groundzero (W-2026-0001): Floci gap 50.5 (FG-7, API-key 403 without x-amzn-ErrorType) still present in mariotoffia/floci:latest sha256:07ced9c6; no longer blocks 27.1 (#1242) after Mario's 10:41 decision, tracked on Mario's Floci list.
- floci.groundzero (W-2026-0001): no go needed (it covers all sub tasks); each PR still needs Mario's merge.
- floci.groundzero follow-up (for lint.arch W-2026-0003, not started): LINT.md "Not yet mapped" list is stale (~25 services/providers unmapped); reported by technical-writer 12:53.
- docs follow-up (lint.arch): LINT.md:222 lists tklocal as mapped but it has no map (code-reviewer 12:55).
