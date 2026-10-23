# Mario's universal conventions (for minions)

> **MUST: we work as agents, not humans.** Never schedule or defer work to a later time, day or date. Start ready work immediately and send packets at once. The only allowed waits are: waiting on Mario, a named blocker, a busy owner, or a running result that takes N minutes (state N). Estimates are effort, never calendar dates.

> **MUST: auto mode (default).** You never ask Mario questions unless he explicitly says to ask. One go on a work item covers ALL its sub tasks: start every ready sub task at once, in parallel where independent. Decide order, scope, owners and parallelism yourself, or ask the fitting specialist minion. Do not send Mario "which should start", "choose all that apply" or similar questions. The only things for Mario are: the go for a NEW work item, a real design/architecture decision only he can make, and merges.

> **MUST: sub tasks never need a go.** The start gate applies ONLY to a NEW work item (a new W-id). Every task, sub task, wave, follow-up or newly-unblocked step inside an approved work item is already approved: start it the moment it is ready, never ask Mario "go?", never send him a widget or multi-select to pick tasks. Approved work items (full go, all sub tasks): **W-2026-0001**. Asking Mario for a go on a sub task of an approved item is a defect.

> **MUST: clean caches after each task.** When a task or sub task finishes (done, PR pushed), its owning coordinator (Dev Lead for code, QA Lead for test runs, Platform Lead for infra) runs `make clean-caches` in `/workspace/repos/teos`, or delegates it, but ONLY when the minions are in sync: no `go build`/`go test`/lint/Floci/cdk run is active on the shared computer (check `pgrep -af 'go (build|test|run)|golangci|floci|cdk|jsii'` is empty and no in-progress sub task is mid-run). If something is running, wait for it and retry; never kill another minion's run. If `go clean -cache` fails with "directory not empty", a build started meanwhile: wait and rerun. Log it in STATUS.md with `df -h /` and `df -i /` after. If disk or inodes exceed 85%, report it to the CTO at once.

> **MUST: PR settings.** Every PR: assignee `mariotoffia` (`gh pr create ... -a mariotoffia`, or `gh pr edit <N> --add-assignee mariotoffia` for existing ones). The PR body must hold one closing keyword line per implemented issue, e.g. `Closes #1231` (repeat for each: `Closes #A`, `Closes #B`; for another repo `Closes Thiink-LLC/<repo>#N`). Never use `Refs`/`Related` for implemented issues. GitHub then closes the issues automatically when the PR is merged into the default branch. Verify with `gh pr view <N> --json assignees,closingIssuesReferences`: it must list mariotoffia and every implemented issue. If the PR targets a non-default branch (auto-close does not fire), the PR owner closes the issues with `gh issue close <N> --reason completed` right after the merge.

> **MUST: GitHub issue per work item / PR.** Before opening any PR, create (or reuse) a GitHub issue for it in the target repo and link it from the PR body (`Closes #N`). On the issue: assign `mariotoffia`; add fitting labels chosen ONLY from the repo's existing labels (never create new labels); set the org/enterprise project fields **Priority** and **Size** using their existing option values; leave **Roadmap** unset; add it to the Project **"R&D Sprint Board"** with status **Incoming**. The minion opening the PR (or its coordinator) owns this; it needs no extra go.

> **MUST: do what you're told.** A go relayed by Solo or your coordinator is Mario's go. Ask Mario only for real design or architecture discussion or decisions only he can make.

This file holds Mario's standards that apply to **every** project the minions work on. It is generic on purpose. Project specifics (module names, make targets, library choices, folder names) come from the **target repo's own `AGENTS.md` and docs, which are authoritative**. If this file and the repo disagree on a project detail, the repo wins; report the drift to the technical-writer minion through your coordinator. If the repo is silent, this file is the default.

---

## §0 Ground rules (every project)

| Rule | Why |
|---|---|
| Read the target repo's `AGENTS.md` first, then the **local docs of the service you touch** (§3), then root docs. | Context lives next to the code. |
| Every project is **DDD + hexagonal (ports & adapters) + clean architecture**. No exceptions without an ADR. | Mario always builds this way. |
| Dependencies point **inward**: adapters → application → domain. Domain imports nothing from frameworks, cloud SDKs, transport or persistence. | Clean architecture rule. |
| Ports (interfaces) are owned by the core; adapters implement them and stay thin. Composition root (`cmd/`, `main`, `app/`) wires them. | Hexagonal. |
| Model with the ubiquitous language of the bounded context: aggregates, entities, value objects, domain events, repositories. Translate third-party models in an anti-corruption layer. | DDD. |
| **Both** the standard linter **and** arch-lint run on every change (§1). Arch-lint config changes need an ADR + Lead Architect minion approval. | Keeps minions in line. |
| Stored data evolves additively unless an ADR says otherwise; schema/key changes are always-gates. | Safe rollouts. |
| Keep files small (~600 lines guide); split code and docs rather than cutting content. | Reviewability. |
| Comments and docs describe what the code **is**. No plan/task IDs, commit hashes or history stories in code. | Durable docs. |
| Plain, simple English in docs, PRs and commits. Conventional commits. | Readability. |
| Work in an isolated git worktree per work item; delete after merge. | Isolation. |
| No secrets in code, logs, commits or chat. | Security. |

## §1 Quality gates (every code change)

A change is done only when **all** gates for every language it touches are green. Put commands + pass/fail in the `done` reply; a failing gate = `blocked: verify-failed`. Prefer the repo's make/npm targets when they exist.

| Gate | Go | TS / web | Other languages |
|---|---|---|---|
| Format | `gofmt`/`goimports` | Prettier | language formatter |
| **Standard linter** | `golangci-lint run` (repo `.golangci.yml`) | ESLint `--max-warnings=0` | the ecosystem's standard linter (e.g. ruff, clippy, ktlint) |
| **Arch-lint** (dependency direction) | `go-arch-lint check` (`.go-arch-lint.yml` per module) | eslint-plugin-boundaries / `import/no-restricted-paths` or dependency-cruiser | import-linter (Py), ArchUnit (JVM), cargo-deny/modules rules (Rust) |
| Vet / typecheck | `go vet` | `tsc --noEmit` (strict) | type checker |
| Unit tests | `go test` (no Docker/cloud) | Vitest/Jest | — |
| Integration / service tests | build-tagged tests with local emulators | Playwright / component tests | — |
| Dependency hygiene | `go mod tidy` → clean diff | lockfile clean diff | — |

Rules: never disable a linter or arch rule inline without a justification comment and reviewer approval; never weaken an arch-lint rule to make a change pass.

## §2 Architecture layout (language-neutral)

```text
<service>/
  domain/          # aggregates, entities, value objects, domain events, domain services (pure)
  application/     # use cases / command & query handlers, port interfaces (driving + driven)
  adapters/
    inbound/       # http, lambda, queue consumers, CLI → call application
    outbound/      # persistence, messaging, third-party clients → implement driven ports
  cmd/ | main      # composition root only
```

Go repos often spell this `internal/core/{domain,ports,services}` + `internal/adapters/...`; TS repos `src/{domain,application,adapters}`. Use the repo's spelling; the dependency direction is what arch-lint enforces.

## §3 Docs locality

Each microservice keeps **its own docs locally**, so all of its context is in one place:

```text
<service>/
  DDD.md           # bounded context, aggregates, invariants, events, context map
  UBIQUITOUS.md    # glossary of the context's terms
  ARCHITECTURE.md  # layers, ports, adapters, deployment shape
  LINT.md          # linter + arch-lint rules specific to this service
  adr/             # service-local ADRs (NNNN-title.md)
  plans/           # service-local plans, feature specs, task breakdowns
```

Repo-wide material lives at the repo root: `docs/` (cross-cutting docs), `adr/` (repo-wide ADRs), `plans/` (cross-service plans). If the repo uses different names, follow the repo.

Minion rules:
- **Before working**, read the touched service's local `DDD.md`, `UBIQUITOUS.md`, `ARCHITECTURE.md`, `LINT.md` and relevant `adr/` + `plans/`, then the root docs.
- **Write** an ADR/plan to the service's local `adr/` / `plans/` when it affects one service; to root `adr/` / `plans/` when it spans services or the repo.
- Update the local docs in the same PR as the code that changes them (new term → `UBIQUITOUS.md`, new aggregate/event → `DDD.md`, new port/adapter → `ARCHITECTURE.md`, new rule → `LINT.md`).

## §A Microservice scaffolding checklist

### A.0 Language-neutral steps
1. Confirm the bounded context and name with the Lead Architect minion (ADR in root `adr/` if it's a new context).
2. Create the layout from §2 and the local docs set from §3 (`DDD.md`, `UBIQUITOUS.md`, `ARCHITECTURE.md`, `LINT.md`, `adr/`, `plans/`).
3. Write the domain first (TDD): aggregates, value objects, invariants, domain events — no framework imports.
4. Define ports in the core; implement use cases against ports.
5. Add adapters (inbound/outbound) behind ports; keep them thin; third-party DTOs stay in adapters (ACL).
6. Wire everything in the composition root only.
7. Add arch-lint config enforcing domain ← application ← adapters, and register the service with the repo's standard linter config.
8. Add build/test targets (Makefile or package scripts) matching the repo's conventions: fmt, lint, lint-arch, vet/typecheck, test, test-integration.
9. Tests: unit (domain, use cases with fake ports), integration (adapters against emulators), contract tests for APIs/events.
10. API/event specs if the service exposes any (§G); infra/manifest if deployable (§F).
11. Run all §1 gates; record results in the `done` reply.

### A.1 Go
- Module per service (or package in a workspace per repo rules); `go mod tidy`, never hand-edit `go.mod`.
- Layout e.g. `cmd/<svc>/main.go`, `internal/core/{domain,ports,services}`, `internal/adapters/{inbound,outbound}/...`.
- `.go-arch-lint.yml`: components for domain, ports, services, adapters, cmd; domain depends on nothing; adapters may not import each other's internals.
- Lint: `golangci-lint run` with repo config (depguard/forbidigo to ban cloud SDKs in domain).
- Tests in `<pkg>_test` packages; integration tests behind build tags.
- Use the repo's context/logging/error helpers if `AGENTS.md` names them.

### A.2 TypeScript / web
- Package in the repo workspace (pnpm/npm workspaces); TS `strict: true`.
- Layout `src/{domain,application,adapters,ui|infrastructure}`; UI components never import adapters directly — go through application hooks/use cases.
- ESLint (repo config, `--max-warnings=0`) **plus** boundaries rules (eslint-plugin-boundaries or dependency-cruiser) encoding the layer direction.
- `tsc --noEmit`, Vitest for unit, Playwright for e2e; Prettier.
- Consume design tokens from the shared token package; no hard-coded design values.

## §B Third-party integration adapter
- Lives in `adapters/outbound` (or a dedicated integration service); anti-corruption layer maps third-party DTOs to domain types.
- Idempotent consumers, retries with backoff, DLQ; secrets from the secret store only.
- Contract/fixture tests; live third-party e2e tests behind build tags/flags, never in default CI.

## §C Shared library
- Pure, documented public API; its own arch-lint config; no dependency on services.
- Own `ARCHITECTURE.md`/`LINT.md`; ADR for breaking API changes; semantic versioning.

## §D Web app / package
See §A.2. Also: accessibility checks, routing/state per repo standard, API clients generated from specs.

## §E CLI / agent binary
- Thin `main` → application use cases; same hexagonal layout; flags/config validated at the edge.
- Edge/on-prem agents: tolerate intermittent connectivity, buffer locally, version the cloud link payloads.

## §F Infrastructure, data, release
- IaC (e.g. CDK) per service with synth + policy checks (e.g. cdk-nag) and template tests.
- Data store changes additive; key/schema changes are always-gates.
- Versions/locks/CHANGELOG change only through the release-config-mgr minion; prod deploy is an always-gate.

## §G API and event specs
- OpenAPI for HTTP, AsyncAPI/JSON Schema for events; lint specs; generate code from specs; version payloads; errors as RFC 9457 Problem Details unless the repo says otherwise.

## §H Docs
- Follow §3 locality. Plain English, short files, docs build must pass, spell-check if configured.

## §I Tests
- Test pyramid: many unit, fewer integration, few e2e. Red test first for behaviour changes. Never weaken assertions to go green.

## Git workspace & start gate

- **One shared Linux computer.** All minions share it. Repos are cloned once at `/workspace/repos/<repo>` (GitHub account `@mariotoffia`, connected).
- **One worktree per work item — only after the start gate.** Each work item gets its own `git worktree` at `/workspace/repos/<repo>/.worktrees/<work-id>` on branch `minion/<work-id>`. Every minion on that item works in that shared worktree. Never tar or copy source between machines. Cloud coding agents (launched only by Dev Lead) push to that same branch.
- **HARD START GATE.** No minion creates a worktree or branch, clones for implementation, or starts implementation work until the work item has Mario's go (e.g. "start", "go") and Mario is in full agreement. Agreement on a spec is **not** a start signal. The go may come from Mario directly **or** be relayed by Solo (Mario's main assistant) or the minion's coordinator (its `reports_to`). A relayed go **is** Mario's go: never ask Mario to reconfirm it. A work item that has a go covers all of its sub-tasks, including unparked or resumed ones; no new go is needed.
- **Do what you're told.** When Solo, your coordinator or Mario gives you a task, do it. Do not ask for permission or confirmation. Ask Mario only when it really needs him: a design or architecture discussion where he wants to be grilled or consulted, a real open product or design decision, a conflict with a MUST rule, or a step this pack reserves for Mario (merges, real-AWS deploys, secrets). If unsure, ask your coordinator, not Mario.
- The coordinator records the go message (Mario's own, or as relayed by Solo or the coordinator) and timestamp in `work/<id>/STATUS.md` (state `go-approved`) before issuing any `implement` packet, and copies it into the packet's `start_gate: {approved_by, at, quote}` field (PACKET_SCHEMA.md). Specialists refuse `implement` packets that lack it or don't match STATUS.md.
- Applies at **every autonomy level**, including `autonomous` and `autonomous-merge`.

## Repository flows are authoritative (all minions)

1. Before any task, read the target repo's root `AGENTS.md` **and every document it references** (e.g. `GITHUB.md`, lint/arch docs, service-local docs). `AGENTS.md` and its linked docs override this pack.
2. Follow **all** flows the repository defines (git, PR, review, CI/workflows, release) exactly as written there. If the repo is silent, use the generic default below.
3. Generic default delivery flow (after the start gate / Mario's go only):
   - One worktree per work item: `<repo>/.worktrees/<work-id>` on branch `minion/<work-id>`.
   - Commit and push only that branch; open a GitHub PR to the repo's default branch.
   - Run all internal minion reviews first (code, test, architecture, security as assigned by the coordinator).
   - The Dev Lead minion requests the GitHub Copilot review as soon as the draft PR opens (marking it ready), waits 10 minutes, has all comments fixed and loops until clean.
   - Ensure all GitHub workflows (CI checks) are green before asking Mario to merge. Never merge, force-push or push to main/protected branches.
4. If a repo flow conflicts with this pack or is unclear, stop and escalate to your coordinator.

## Implementation goes to specialist minions (Mario, 2026-10-21)

- Coordinators (CTO, PO, Dev Lead, Project Lead, Platform Lead, QA Lead, Lead Architect) plan, split, route and gate; they do **not** implement and do **not** hand coding to Cursor cloud agents.
- Every implementation task is sent as a work packet to the matching specialist minion (e.g. Core Services Developer (Go), Frontend Developer, AWS Serverless & CDK Specialist, Data Store Specialist, Edge Agent Engineer), working in a worktree on the shared computer.
- Tests are written by the Test Designer minion; before any PR, the Code Reviewer, Hexagonal Architecture Reviewer and Clean Architecture Reviewer minions review it, plus Security Auditor or Test Reviewer when relevant. Then follow the repo PR/Copilot/workflow flow.
- Cursor cloud agents are used only when Mario explicitly asks for them.

## No calendar scheduling (Mario, 2026-10-21)
Minions are not a human team: there are no working days, nights or weekends. Never schedule work for a later date. When a task is ready (gate cleared, owner free, no blocker), start it **immediately**, and send its packets/doorbells at once (don't leave them as drafts). Estimates are given in effort/sequence, not calendar start dates. Only waiting on Mario, a blocker or a busy owner may delay work, and the board must name which one.

## Draft PRs early (Mario, 2026-10-21)
Mario reviews changes in the GitHub UI. As soon as a task has its first commit, push its branch and open a **draft** PR (title prefixed with the work id; body links the task and STATUS.md). Keep pushing as work progresses. The Dev Lead minion then marks it ready for review at once and runs the Copilot loop: request Copilot review, wait 10 minutes, fix all comments, re-request, until clean. Internal reviews run in parallel. Never merge.

## Floci-only work items (Mario, 2026-10-21)
W-2026-0001 (Floci groundzero) and any other Floci work item is Floci-only. Do not run tests against or deploy to real AWS, and that includes devlocal. Every gate and every piece of evidence comes from local Floci. A PR is ready to merge once the internal minion reviews pass, Copilot has reviewed it and all workflows are green. The README devlocal rule does not apply to these items.

## MUST: when to delegate and when to do it yourself

**Coordinator minions** (CTO, Dev Lead, Platform Lead, Project Lead, Product Owner, Lead Architect, QA Lead) route work. They do not do it.
- They do only: triage, splitting work into tasks, picking the owner, writing the packet, tracking the board/STATUS, chasing reviews, and answering Mario.
- Everything else is delegated to the specialist whose role fits, even small asks and even when the coordinator could do it quickly. That includes investigations, analysis, inventories, code reading, writing or changing code, tests, docs, Floci or AWS checks, and reviews.
- Rule of thumb: if the task needs more than reading the board and the work files to answer, delegate it.
- Pick the owner from ROSTER.md (for example: Floci or Go code questions go to the Core Services Developer (Go) minion, test coverage questions go to the Test Designer minion, CDK/AWS questions go to the AWS Serverless & CDK Specialist minion). If two specialists fit, split the work or pick one and name the other as reviewer.
- If no specialist fits, or every fitting one is busy, say so on the board (waiting on a busy minion) or ask your coordinator/Mario. Do the work yourself only when Mario explicitly asks you to.
- Tell the asker who you delegated to and where to follow it (board row, work item, PR).

**Specialist minions** do the work inside their role themselves. They hand off, through their coordinator, any part that falls outside their role (for example a reviewer does not fix code; a Go developer does not write the CDK stack).

## Board format (Mario, 2026-10-22)
- Who: the owner coordinator updates the board on every status change; each change sets Last updated to Stockholm time `YYYY-MM-DD HH:MM` (real timestamps from files/git/PRs, UTC converted; else file mtime; never invented).
- Layout: "Legend" section first, then "How to update this board", then one table `Task | Sub task | Description | Status | Last updated`, then a "Blocked on Mario" list.
- One row per sub task plus a parent row with the Sub task cell blank. Description is one short line and starts with the W-id on the parent row (e.g. "W-2026-0004: …").
- Status is only one of four icons: ✅ done, 🔄 progress, 📐 designed, ⏳ waiting. New items start as ⏳.
- Never delete done rows. Move them within the table instead; done rows stay in the table.
- Names are short, unique, dotted lowercase (`makefile.linux`, `floci.groundzero`). Sub tasks from another list keep the remote id, optionally with a short slug (`27.16.3`, `T1 os-detect`).

## GitHub issue fields (Priority, Size): how to set them
Verified 2026-10-22 against #1231. Org `Thiink-LLC`. The `gh` token needs the `project` scope; check with `gh auth status | grep project`. If it's missing, report BLOCKED (Solo refreshes it by device code). Never skip a failed step silently.

**Priority and Size are ORG ISSUE FIELDS on the issue itself, not Project fields.** Their Project counterparts have no options. Setting them through `gh project item-edit` does nothing.

1. **Issue:** `gh label list -R Thiink-LLC/<repo>`, then `gh issue create -R Thiink-LLC/<repo> -t "<W-id> T-<x>: <title>" -b "<body>" -a mariotoffia -l "<existing labels>"`. Get its node id with `gh issue view <N> -R Thiink-LLC/<repo> --json id -q .id`.
2. **Priority and Size, in one mutation:**
```
gh api graphql -f query='mutation($i:ID!,$p:ID!,$s:ID!){setIssueFieldValue(input:{issueId:$i,issueFields:[{fieldId:"IFSS_kgDOAVq1qQ",singleSelectOptionId:$p},{fieldId:"IFSS_kgDOAsLCxw",singleSelectOptionId:$s}]}){clientMutationId}}' -f i=<ISSUE_NODE_ID> -f p=<PRIO_OPT> -f s=<SIZE_OPT>
```
   - Priority (`IFSS_kgDOAVq1qQ`): Urgent `IFSSO_kgDOAl6mDA`, High `IFSSO_kgDOAl6mDQ`, Medium `IFSSO_kgDOAl6mDg`, Low `IFSSO_kgDOAl6mDw`
   - Size (`IFSS_kgDOAsLCxw`): Hours `IFSSO_kgDOBNUasQ`, Days `IFSSO_kgDOBNUasg`, Split `IFSSO_kgDOBNUasw`
   - Leave **Roadmap** and **Effort** unset. Never create fields or options.
   - If an id stops working, refresh them with `gh api graphql -f query='{organization(login:"Thiink-LLC"){issueFields(first:20){nodes{... on IssueFieldSingleSelect{id name options{id name}}}}}}'`.
3. **Project "R&D Sprint Board"** (number 2, id `PVT_kwDOBoJzxs4BKY5X`): `ITEM=$(gh project item-add 2 --owner Thiink-LLC --url <issue-url> --format json -q .id)`
4. **Status = Incoming:** `gh project item-edit --project-id PVT_kwDOBoJzxs4BKY5X --id $ITEM --field-id PVTSSF_lADOBoJzxs4BKY5Xzg6RWQI --single-select-option-id 1f493ca5`
4b. **Sprint = latest sprint (discover every time; never hardcode):**
```
SPRINT=$(gh api graphql -f query='{node(id:"PVT_kwDOBoJzxs4BKY5X"){... on ProjectV2{field(name:"Sprint"){... on ProjectV2IterationField{configuration{iterations{id title startDate}}}}}}}' --jq '.data.node.field.configuration.iterations|sort_by(.startDate)|last|.id')
gh project item-edit --project-id PVT_kwDOBoJzxs4BKY5X --id $ITEM --field-id PVTIF_lADOBoJzxs4BKY5Xzg7d7CM --iteration-id $SPRINT
```
   `iterations` lists only the current and upcoming sprints (finished ones are in `completedIterations`, never use those). Pick the one with the newest startDate (on 2026-10-22 that was "Sprint 21"). If the list is empty, report BLOCKED instead of skipping.
5. **Verify (definition of done; paste the output into STATUS.md):**
   - `gh issue view <N> -R Thiink-LLC/<repo> --json projectItems` must show R&D Sprint Board with status Incoming, and `gh project item-list 2 --owner Thiink-LLC --format json --limit 1000 --jq '.items[]|select(.content.number==<N>)|.sprint'` must show the latest sprint.
   - `gh api graphql -f query='{repository(owner:"Thiink-LLC",name:"<repo>"){issue(number:<N>){issueFieldValues(first:10){nodes{... on IssueFieldSingleSelectValue{name field{... on IssueFieldSingleSelect{name}}}}}}}}'` must show Priority and Size.

Pick values yourself (auto mode). Size is Hours for less than a day, Days for longer, and Split when the item should be broken up. Priority follows urgency; the default is Medium.
