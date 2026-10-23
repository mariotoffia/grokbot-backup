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
| floci.groundzero |  | W-2026-0001: Floci-only groundzero tasks W1–W4, owner dev-lead; box env OK (docker, make, arm64 aarch64); Mario merged #1248, #1255, #1250 (15:26–15:36) and #1263 (16:42); #1242 closed (Floci-only rule); open: #1252 @f234681a ready for Mario's merge (👀); docs.ingestionsvc #1258 not started | 🔄 | 2026-10-23 18:08 |
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
| floci.groundzero | 27.16.4 | FG-1 fixed on floci:latest 07ced9c6; PR #1255 (Closes #1232) MERGED by Mario 15:28 at 9f33caca (98331222); r4 Copilot fixes c402a3f4 pushed after merge, not on main -> follow-up PR needed (dev-lead) | ✅ | 2026-10-23 15:40 |
| floci.groundzero | 27.16.4a | ingestionsvc go-arch-lint map, PR #1257 (Closes #1256) HEAD 7139f4b8: code + hexagonal + Lead Architect APPROVED; marked ready, Copilot clean (0 comments) (golang-pro); LINT.md count restack needed if #1250 merges first ; MERGED by Mario | ✅ | 2026-10-23 15:33 |
| floci.groundzero | adr.0001 | umbrella ADR go-arch-lint map per service, PR #1260 (code + LA APPROVED @105a4eff; ready, Copilot CLEAN @3d8f6dea; code + LA APPROVED @392d8a7e; Copilot CLEAN @392d8a7e; merge-ready) (Closes #1259) at 392d8a7e (technical-writer): Lead Architect content check + code review ; MERGED by Mario (01910b2b) | ✅ | 2026-10-23 15:35 |
| floci.groundzero | docs.ingestionsvc | follow-up issue #1258 ingestionsvc service docs (filed, Incoming, not started) | ⏳ | 2026-10-23 12:48 |
| floci.groundzero | 39.11 | W3: delete the 2 GoBridge skips (#1234) | ✅ | 2026-10-23 09:15 |
| floci.groundzero | 27.16.1 | W4: eventsvc ESM/alarm/runtime (#1240) | ✅ | 2026-10-23 09:18 |
| floci.groundzero | 27.1 | W4: APIGW v1 contract cases (#1242): closed unmerged 15:26 and #1241 closed not planned, per Mario 15:24 Floci-only rule (audit: Floci-only MOCK API); branch kept | ✅ | 2026-10-23 15:40 |
| floci.groundzero | 27.27 | W4: remove Cognito CustomDomain workarounds (#1236) | ✅ | 2026-10-23 09:17 |
| floci.groundzero | 27.27a | buildingsvc go-arch-lint map, PR #1250 (Closes #1249): code + hexagonal + Lead Architect APPROVED, merge-main 37d14373 code delta APPROVED; MERGED by Mario 15:36 (865f50cc) | ✅ | 2026-10-23 15:40 |
| floci.groundzero | machine.setup | Linux build box setup script (#1248): code + security APPROVED, Copilot clean at 36292726; MERGED by Mario 15:26 (ec00bd89) | ✅ | 2026-10-23 15:40 |
| floci.groundzero | machine.setup.arm64 | Follow-up #1252 (Closes #1251, arm64 binfmt; IPv6 docker rules + dnsmasq/DOCKER-USER v6 hardening; release-config-mgr) @f234681a: code (Delta 11) + security APPROVED @f234681a (Low L-1 open, non-blocking); Copilot review of f234681a: no open issues, 0 unresolved threads; checks green (Build/unit skipped, waived by Mario 17:09–17:10); waiting on Mario's merge | 👀 | 2026-10-23 18:08 |
| floci.groundzero | 27.29 | W4: un-skip SUR LogImport (#1238) | ✅ | 2026-10-23 09:17 |
| floci.groundzero | 27.16.4b | #1255 post-merge Copilot fixes as PR #1263 (Closes #1262) @0cc8726b: code + test APPROVED, Copilot clean; MERGED by Mario 16:42 (golang-pro, dev-lead) | ✅ | 2026-10-23 16:43 |
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
| ops.cleanup |  | Post-merge cleanup (Mario 16:07): 14 merged worktrees/branches removed, clean-caches run; disk 40G->26G used. Kept #1252, #1263, #1240 (local 376519e6), backup b627fdaf. Periodic: dev-lead triggers, release-config-mgr executes | ✅ | 2026-10-23 16:14 |
| ops.cleanup | cleanup.r3 | Post-merge cleanup round 3 (#1263, #1265): worktrees/branches removed, main ff f3a1d6d7, clean-caches incl. golangci; disk 27G->24G used | ✅ | 2026-10-23 16:45 |
| build.clean-caches-golangci |  | make clean-caches also clears golangci-lint cache (Mario go 16:24 via Solo); issue #1264, PR #1265 @04c99d00 (cache clean only, no fallback per Mario 16:25): code APPROVED, Copilot clean, checks green; MERGED by Mario 16:42 (release-config-mgr) | ✅ | 2026-10-23 16:43 |

## Blocked on Mario

- makefile.linux (W-2026-0004): go for T1–T17 (requested 2026-10-22 13:42 in #teos-grokbot).
- hostarch.builds (W-2026-0002): go to start, after floci.groundzero is done (needs an ADR).
- lint.arch (W-2026-0003): go to start.
- floci.groundzero (W-2026-0001): Floci gap 50.5 (FG-7, API-key 403 without x-amzn-ErrorType) still present in mariotoffia/floci:latest sha256:07ced9c6; no longer blocks 27.1 (#1242) after Mario's 10:41 decision, tracked on Mario's Floci list.
- floci.groundzero (W-2026-0001): no go needed (it covers all sub tasks); each PR still needs Mario's merge.
- floci.groundzero follow-up (for lint.arch W-2026-0003, not started): LINT.md "Not yet mapped" list is stale (~25 services/providers unmapped); reported by technical-writer 12:53.
- docs follow-up (lint.arch): LINT.md:222 lists tklocal as mapped but it has no map (code-reviewer 12:55).
- floci.groundzero (W-2026-0001): Mario 15:24 Floci-only rule — audit done: only #1242 is Floci-only (closing); #1255 keeps all (real TEOS path); rest infra/lint/docs. 15:27
