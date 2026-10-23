# Work packet schema

Coordinators send one packet per specialist (or self-task). Specialists execute **exactly that packet** and return `done` / `blocked` / `escalate`. Phase sequencing lives only in coordinators.

Packets are YAML files at:

```text
/workspace/minions/work/<W-id>/packets/<packet.id>.yaml
```

A short `⟦MINION v1 | … | type=handoff⟧` chat line points at the path (doorbell only).

## Schema

```yaml
id: P-2026-0042-07          # unique within the work item (W-id + seq)
work_id: W-2026-0042
type: implement              # see types below
start_gate:                  # REQUIRED for type: implement; omit otherwise
  approved_by: Mario
  at: 2026-10-21T13:44:00+02:00
  quote: "go"                 # the go message (Mario's own, or as relayed by Solo or the coordinator), as in STATUS.md (go-approved)
autonomy: grill-arch         # pair | grill-design | grill-arch | autonomous | autonomous-merge
phase: implementing          # status.json state this packet belongs to
assignee: golang-pro         # roster slug
reply_to: cto                # who gets done/blocked (usually the issuing coordinator)
issued_by: dev-lead
issued_at: 2026-10-21T12:00:00+02:00
ttl: 24h                     # expected completion window

skills_to_use:               # coordinator override; intersection with assignee skills_allow
  - test-driven-development
  - verification-before-completion
skills_forbid: []            # optional hard denylist for this packet

may_consult:                 # optional specialist slugs the assignee may consult once each
  - ddd-reviewer
  - dynamodb-dsql

inputs:
  - kind: brief
    path: /workspace/minions/work/W-2026-0042/brief.yaml
  - kind: f-spec
    path: <repo>/<service>/plans/F-014-….md
  - kind: task
    path: <repo>/<service>/plans/F-014-…/T-03-….md
  - kind: diff
    ref: origin/feat/F-014…   # or patch path
  - kind: note
    text: "Prefer the existing aggregate; do not invent a new one without escalate."

acceptance:                  # testable done criteria for THIS packet
  - id: A1
    text: "standard linter + arch-lint + tests green for package … (CONVENTIONS.md §1)"
  - id: A2
    text: "PR opened into feat/F-014-… with conventional commit"

budget:
  cloud_agent_runs: 1        # if launcher
  fix_loop_rounds: 3
  wall_clock: 8h
  tokens_hint: null

constraints:
  owns: ["<service>/internal/**"]
  read_only: false           # true for reviewers/auditors
  worktree: <repo>/work/git-worktree/W-2026-0042-<slug>
  branch: task/F-014/T-03-<slug>
  no_credentials: true

context_bundle:              # optional pre-resolved paths (specialists read these first)
  ubiquitous: [<repo>/UBIQUITOUS.md, <repo>/<service>/UBIQUITOUS.md]   # service-local first
  ddd: [<repo>/<service>/DDD.md]
  adr: [<repo>/<service>/adr/, <repo>/adr/]
  plans: [<repo>/<service>/plans/, <repo>/plans/]
  architecture: [<repo>/<service>/ARCHITECTURE.md]
  conventions: /workspace/minions/CONVENTIONS.md
  lint: [<repo>/<service>/LINT.md]

on_blocked:
  escalate_to: dev-lead
  reason_codes_ok: [need-input, need-approval, dependency, conflict, verify-failed, ceiling-exceeded, unclear-brief]
```

## Packet types

| `type` | Typical assignee | Expected outputs |
|---|---|---|
| `intake-grill` | product-owner / dev-lead | brief.yaml, PRD |
| `plan` | cto | plan.md |
| `delivery` | project-lead | delivery-plan.md, milestones.yaml, risk-register.md |
| `onboard` | customer-onboarding (via project-lead) | per-customer provision config draft, readiness checklist |
| `design` | lead-architect → specialists | design notes, F-draft |
| `ratify` | lead-architect | frozen F-spec, ADRs |
| `split` | dev-lead | tasks, waves.json, locks |
| `implement` | golang-pro / typescript-frontend / provider-integration / edge-agent / analytics-cep / aws-serverless-cdk | code PR |
| `red-test` | test-designer | failing test file |
| `test-plan` | test-designer | `== Test Plan ==` |
| `review` | *-reviewer, *-auditor, code-reviewer, adversarial-reviewer | `== Verdict ==` |
| `fix` | implementers + systematic-debugging | fix PR + diagnosis note |
| `incident` | observability-sre / dev-lead | runbook fragment, mitigation options |
| `docs` | technical-writer | adoc/md PR |
| `onboard` | customer-onboarding | provision-config (not applied) |
| `release` | release-config-mgr / platform-lead | notes, version bump, deploy plan |
| `consult` | any specialist | ≤500-word design note |

## Reply contract

Assignee appends to `/workspace/minions/work/<work_id>/STATUS.md` on start, milestone, block and finish (README § Progress & status), writes artifacts under `/workspace/minions/work/<work_id>/…`, and replies:

```
STATUS: done | blocked | escalate
PACKET: P-…
ARTIFACTS:
- <path> — <one line>
SUMMARY: …
BLOCKED_REASON: <code>   # if blocked
```

Chat header example:

```
⟦MINION v1 | id=msg-… | w=W-2026-0042 | type=done | from=golang-pro | to=dev-lead | re=msg-… | hop=1 | ttl=24h | state=implementing⟧
```

## Validation rules (CTO / issuing coordinator)

- `assignee` must exist in `ROSTER.md`.
- `skills_to_use` ⊆ assignee `skills_allow` (else strip + log, or reassign).
- Review packets must set `constraints.read_only: true`.
- Missing `acceptance` → reject packet.
- `implement` packets must carry `start_gate {approved_by, at, quote}` identical to the `go-approved` entry in `work/<id>/STATUS.md`; otherwise reject (all autonomy levels).
- `autonomy` must match parent `brief.yaml` unless Mario raised/lowered it.

## Git workspace & start gate

- **One shared Linux computer.** All minions share it. Repos are cloned once at `/workspace/repos/<repo>` (GitHub account `@mariotoffia`, connected).
- **One worktree per work item — only after the start gate.** Each work item gets its own `git worktree` at `/workspace/repos/<repo>/.worktrees/<work-id>` on branch `minion/<work-id>`. Every minion on that item works in that shared worktree. Never tar or copy source between machines. Cloud coding agents (launched only by Dev Lead) push to that same branch.
- **HARD START GATE.** No minion creates a worktree or branch, clones for implementation, or starts implementation work until the work item has Mario's go (e.g. "start", "go") and Mario is in full agreement. Agreement on a spec is **not** a start signal. The go may come from Mario directly **or** be relayed by Solo (Mario's main assistant) or the minion's coordinator (its `reports_to`). A relayed go **is** Mario's go: never ask Mario to reconfirm it. A work item that has a go covers all of its sub-tasks, including unparked or resumed ones; no new go is needed.
- **Do what you're told.** When Solo, your coordinator or Mario gives you a task, do it. Do not ask for permission or confirmation. Ask Mario only when it really needs him: a design or architecture discussion where he wants to be grilled or consulted, a real open product or design decision, a conflict with a MUST rule, or a step this pack reserves for Mario (merges, real-AWS deploys, secrets). If unsure, ask your coordinator, not Mario.
- The coordinator records the go message (Mario's own, or as relayed by Solo or the coordinator) and timestamp in `work/<id>/STATUS.md` (state `go-approved`) before issuing any `implement` packet, and copies it into the packet's `start_gate: {approved_by, at, quote}` field (PACKET_SCHEMA.md). Specialists refuse `implement` packets that lack it or don't match STATUS.md.
- Applies at **every autonomy level**, including `autonomous` and `autonomous-merge`.
