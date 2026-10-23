# Meta folder inventory — agents & skills → "minions" org

Source: `/workspace/thiink/meta` (1,210 text files; Go generator repo `thiink` that renders one Claude-plugin source into Claude/Cursor/Copilot/Codex/Gemini outputs). Generated 2026-10-21.

## 0. What is where (read first)

| Layer | Path | Count | Status |
|---|---|---|---|
| **Canonical agents** (current) | `plugins/thiink/agents/*.md` | 25 | Authoritative, high quality, cross-referenced |
| **Canonical skills** (current) | `plugins/thiink/skills/<name>/` (templates) → rendered `/workspace/thiink/plugin/4.15.0/skills` | 22 SKILL.md (v4.15.0) | Source tree holds `SKILL.md.tmpl` (dropped from the text extract); **§2 now uses the real rendered v4.15.0 files**. `loop` excluded from Claude render by design. |
| Generated/legacy agents | `_dist/md/{cursor,claude}/agents/*.md` | 54 + README (identical sets) | Older generation: 51 upstream VoltAgent personas + 3 legacy `thiink-*`. README claims "71 agents" (stale). |
| Generated/legacy skills | `_dist/md/cursor/skills/*/SKILL.md` | 22 (+ `frontend-design` in claude only) | Older "step-by-step guide" pattern skills. Reference agents by old names (`thiink-test-designer`, `thiink-doc-writer`…) that no longer exist. |
| Examples | `docs/llm/examples/{agents,skills}` | 3 agents, 3 skills | Early prototypes of thiink-code-reviewer / ddd-expert / security-auditor; create-lambda-handler, create-microservice, implement-ddd-aggregate |
| Root guidance | `AGENTS.md`, `examples/todolist/AGENTS.md` | 2 | Repo contributor guidance, not personas |
| Research | `designs/AGENT_BASED_DEVELOPMENT.md`, `.tmp/OPEN_CLAW.md`, `.tmp/HERMES.md` | 3 | Orchestration patterns (orchestrator–worker, fan-out, DAG waves, judge panels) + comparison of OpenClaw/Hermes bot platforms — directly relevant to the "minions" runtime choice |

All 25 canonical agents use frontmatter `name, description, model: inherit, tools, context: fork` (+ optional `mcpServers`, `metadata`). Each reads the governance corpus (`UBIQUITOUS.md`, `DDD.md`, `ARCHITECTURE.md`, `CONVENTIONS.md`, `LINT.md`, `PLUGIN.md`, `TESTS.md`, `docs/adr/*`) walking CWD→repo root, "service-local wins". Two invocation paths (plugin README): *"Gate dispatch — verdict-producing reviewers fired by QA gates…"* and *"Specialist consult — design-time delegates… Produce a ≤500-word design note, not a verdict."*

## 1. Canonical agents (`plugins/thiink/agents/`)

Legend: **Org role** = best mapping to the requested minion org. "Handoffs" quotes the agent's own `## Coordination` / `## Collaborators` section.

| # | Agent | Org role | Purpose | Tools / tech | Key instructions |
|---|---|---|---|---|---|
| 1 | adversarial-reviewer | Tester / Architect (red team) | Devil's-advocate review of a completed feature; questions approach, finds missed edge cases | *No tools/model declared*; inputs: F-spec, cumulative diff, task index, EC test map | "You do NOT have file-write access. You do NOT dispatch sub-agents."; one verdict; output starts `== Verdict ==`; ≤3 ADR candidates; cite file:line |
| 2 | api-designer | Architect (API) | REST/GraphQL design, OpenAPI/AsyncAPI/Protobuf, versioning, pagination, webhooks | Read/Write/Edit/Bash/Glob/Grep | Names from UBIQUITOUS/DDD |
| 3 | architect-aws-serverless | **AWS serverless specialist + DynamoDB** | Lambda, API GW, DynamoDB design, EventBridge, Step Functions, CDK | MCP: aws-documentation, aws-cdk-mcp-server, cloudwatch-mcp-server | Thin handlers ("parse + delegate + map"); DynamoDB access-pattern section; "Cost (delegate detail to `cost-auditor`)" |
| 4 | bff-auditor | Reviewer (architecture) | BFF aggregation, statelessness, no domain logic | R/W/Bash/Grep/Glob | Responsibilities matrix |
| 5 | clean-arch-reviewer | Architect/Reviewer | Dependency direction, layer separation | same | "`BLOCKED` is reserved for the four `BLOCKER` triggers" |
| 6 | code-reviewer | Dev lead (review) | Quality, security, perf across languages | R/W/Edit/Bash | Runs gofmt/golangci-lint/eslint/ruff; "No prose preamble"; **meta-router** (defers to all specialists) |
| 7 | contract-reviewer | Reviewer (contracts) | API/event contract versioning, back-compat, contract tests | same | 3 BLOCKER triggers |
| 8 | cost-auditor | FinOps specialist | Right-sizing, data transfer, storage, anomalies | MCP cloudwatch | Separate review vs advisory output |
| 9 | ddd-expert | Architect (domain) | Aggregates, bounded contexts, events, UL, ACL, event storming | R/W/Bash | "Use the glossary names exactly." |
| 10 | doc-asciidoc-reviewer | Docs reviewer | `.adoc` + `_design/` voice/toolchain | same | Quick-replacement table |
| 11 | doc-asciidoc-writer | Tech writer | AsciiDoc, Kroki SVG, tagged includes, audiences | +Edit | Design-system colors, icon legend |
| 12 | doc-markdown-reviewer | Docs reviewer | GFM + governance docs | same | File-type rules |
| 13 | doc-markdown-writer | Tech writer | Governance docs, Mermaid | +Edit | Owns governance file format spec |
| 14 | event-architect | Architect (events) | Domain events, schema evolution, outbox, bus routing | same | Event schema template |
| 15 | golang-pro | **Developer** (only implementer) | Idiomatic Go, concurrency, tests, AWS SDK v2 | +Edit | Reads CONVENTIONS/LINT |
| 16 | hexagonal-reviewer | Architect/Reviewer | Ports & adapters | same | Example layout |
| 17 | kpi-architect | **Analytics** / PO support | Business KPIs, thresholds, SLAs, dashboards | MCP grafana | Design vs review outputs |
| 18 | messaging-expert | Specialist | Envelopes, headers, idempotency, fencing, outbox, error catalog | same | Explicit ownership split with event-architect |
| 19 | observability-expert | DevOps/SRE | Logging, metrics, tracing, incidents | MCP grafana, cloudwatch | **Missing `context: fork`** |
| 20 | resilience-auditor | SRE | Timeouts, CB, bulkheads, retries | same | Detection patterns |
| 21 | runtime-expert | Specialist (platform) | Composition root, registries, Plan→Commit, middleware, lifecycle | same | |
| 22 | saga-expert | Architect (workflows) | Orchestrated/choreographed sagas, compensation | same | Style-selection table |
| 23 | security-auditor | Security | AuthN/Z, IAM, secrets, tenancy | same | "full-clarity warnings (auto-clarity exception)" |
| 24 | test-designer | **Tester** (design) | Red-stage failing test (Step 4a), fix-loop test plans (6.6), categories | same | Unit/Integration/Simulation/E2E/Bench; determinism |
| 25 | test-reviewer | Tester (gate) | Test quality, determinism, EC coverage gate | same | Mandatory EC coverage gate vs F-spec |

### 1.1 Handoffs — quoted (all 25 except adversarial-reviewer define them)


**api-designer**
> - `contract-reviewer` — schema evolution, semver rules, backward compatibility.
> - `event-architect` — event design specifics behind webhook / async endpoints.
> - `messaging-expert` — envelope / idempotency / header conventions on async endpoints.
> - `bff-auditor` — when the API is a BFF aggregating downstream services.
> - `security-auditor` — auth/IAM depth, rate limiting.
> - `code-reviewer` — implementation quality of the generated handlers.

**architect-aws-serverless**
> - `ddd-expert` — DDD specifics, aggregate boundaries.
> - `contract-reviewer` — schema versioning and backward compatibility.
> - `saga-expert` — orchestrated and choreographed saga design.
> - `cost-auditor` — cost-only audits (right-sizing, data transfer, storage).
> - `resilience-auditor` — resilience-only audits (retry, circuit breaker, timeouts).
> - `runtime-expert` — composition root, plugin registry, lifecycle of Lambda / container entry points.
> - `messaging-expert` — envelope shape, header namespaces, outbox row design, fencing tokens.
> - `observability-expert` — CloudWatch metrics, tracing, alerting.
> - `security-auditor` — IAM policies, KMS keys, secret stores.
> - `code-reviewer` — broader code quality.

**code-reviewer**
> - Defer architecture-layer findings to `clean-arch-reviewer`, `hexagonal-reviewer`, `ddd-expert`.
> - Defer API/event-schema findings to `contract-reviewer`.
> - Defer composition-root / plugin registry / lifecycle findings to `runtime-expert`.
> - Defer envelope / header / fencing / outbox / credential-redaction findings to `messaging-expert`.
> - Defer event design to `event-architect`; saga design to `saga-expert`.
> - Defer resilience patterns (retry, circuit breaker, timeout) to `resilience-auditor`.
> - Defer cost-only audits to `cost-auditor`.
> - Defer logging/metrics/tracing gaps to `observability-expert`.
> - Defer auth/IAM/tenancy depth to `security-auditor` — but still surface obvious security issues here.
> - Defer test design gaps to `test-designer` / `test-reviewer`.

**cost-auditor**
> - `kpi-architect` — SLA threshold setting and cost/business-outcome KPIs.
> - `resilience-auditor` — raw resilience trade-offs (timeout, retry budgets) that affect cost.
> - `security-auditor` — cross-account / IAM cost concerns.
> - `observability-expert` — metric and log retention that drive cost.
> - `runtime-expert` — lifecycle, drain, and warm-pool decisions with cost impact.
> - `architect-aws-serverless` — topology decisions (provisioned concurrency, on-demand vs reserved).
> - `code-reviewer` — broader code quality.

**ddd-expert**
> - `clean-arch-reviewer` — layer boundaries and dependency direction.
> - `event-architect` — event design semantics.
> - `hexagonal-reviewer` — port/adapter shape.
> - `contract-reviewer` — event schema versioning.
> - `messaging-expert` — outbox-as-aggregate, credential value objects, structured error type.
> - `runtime-expert` — composition root that wires aggregates and repositories.

**doc-asciidoc-reviewer**
> - `doc-asciidoc-writer` — the writer producing the docs under review; loops back to fix findings.
> - `doc-markdown-reviewer` — sibling reviewer for Markdown surface; share voice rules.
> - `code-reviewer` — when AsciiDoc embeds source code with tagged regions.

**doc-asciidoc-writer**
> - `doc-asciidoc-reviewer` — reviewer that gates AsciiDoc output.
> - `doc-markdown-writer` — sibling writer for Markdown governance docs; share voice rules.
> - `ddd-expert` / `clean-arch-reviewer` / `hexagonal-reviewer` — source-of-truth for architecture and glossary content the docs describe.

**doc-markdown-reviewer**
> - `doc-markdown-writer` — the writer producing the docs under review; loops back to fix findings.
> - `doc-asciidoc-reviewer` — sibling reviewer for AsciiDoc surface; share voice rules.
> - `ddd-expert` — when reviewing UBIQUITOUS.md / DDD.md for glossary correctness (not just voice).
> - `clean-arch-reviewer` — when reviewing ARCHITECTURE.md for layer-diagram correctness.

**doc-markdown-writer**
> - `doc-markdown-reviewer` — reviewer that gates Markdown output.
> - `doc-asciidoc-writer` — sibling writer for AsciiDoc design docs; share voice rules.
> - `ddd-expert` / `clean-arch-reviewer` / `hexagonal-reviewer` — source-of-truth for governance content (UBIQUITOUS.md, DDD.md, ARCHITECTURE.md).

**event-architect**
> - `messaging-expert` — envelope shape, reserved header namespace, idempotency, fencing, outbox-as-aggregate.
> - `contract-reviewer` — schema versioning and backward compatibility for event payloads.
> - `ddd-expert` — events must be raised from the aggregate method that performs the state change.
> - `saga-expert` — events that participate in choreographed sagas.
> - `runtime-expert` — the runtime that publishes and dispatches the events.
> - `code-reviewer` — broader code quality.

**golang-pro**
> - `clean-arch-reviewer` — layer placement and dependency direction.
> - `hexagonal-reviewer` — port shape and adapter thinness.
> - `ddd-expert` — aggregate behaviour and ubiquitous-language consistency.
> - `runtime-expert` — composition root, plugin registry, lifecycle methods.
> - `messaging-expert` — envelope / header / idempotency / fencing / credential redaction.
> - `test-designer` / `test-reviewer` — test plan, test quality, determinism.
> - `security-auditor` — auth/IAM, secret handling.
> - `resilience-auditor` — timeout, retry, circuit-breaker patterns.
> - `observability-expert` — structured logging, metrics, tracing.
> - `code-reviewer` — meta reviewer for general quality.

**hexagonal-reviewer**
> - `clean-arch-reviewer` — overall layer structure and dependency direction.
> - `ddd-expert` — aggregate design within the hexagon core.
> - `runtime-expert` — composition root and factory/registry binding adapters to ports.
> - `messaging-expert` — port types for messaging primitives (envelope, headers, outbox).
> - `code-reviewer` — broader code quality.

**kpi-architect**
> - `observability-expert` — raw instrumentation (logging, metric emission, span shape).
> - `cost-auditor` — cost-only metrics.
> - `resilience-auditor` — resilience-specific signals (DLQ, retry, circuit-breaker counts).
> - `contract-reviewer` — KPI definitions are contracts with downstream dashboards.
> - `messaging-expert` — KPIs derived from envelope metadata (latency-by-correlation, fan-out).
> - `runtime-expert` — KPIs derived from lifecycle / pipeline metrics.
> - `security-auditor` — KPIs on auth failures, suspicious access patterns.

**messaging-expert**
> - `event-architect` — event schema and producer/consumer design (overlap on envelope; this agent owns headers, idempotency, fencing, secret-safety; `event-architect` owns the payload semantics).
> - `contract-reviewer` — schema versioning, backward compatibility.
> - `ddd-expert` — outbox-as-aggregate is a DDD pattern; aggregate invariants belong to `ddd-expert`.
> - `saga-expert` — fencing tokens often appear in saga compensation paths.
> - `security-auditor` — credential / secret leak surface is cross-listed.
> - `runtime-expert` — the runtime processes envelopes and drives the outbox; messaging-expert defines the shape, runtime-expert defines the wiring.
> - `clean-arch-reviewer` — keeps transport types out of the domain envelope.
> - `code-reviewer` — general code quality.

**observability-expert**
> - `kpi-architect` — business-aligned KPIs derived from raw metrics.
> - `resilience-auditor` — telemetry for resilience signals (DLQ counts, circuit-breaker state, retry counts).
> - `cost-auditor` — log/metric retention with cost impact.
> - `runtime-expert` — lifecycle / supervisor / pipeline metrics.
> - `messaging-expert` — span / log conventions around envelope correlation, causation, fencing.
> - `saga-expert` — correlation-ID propagation for saga visibility.
> - `security-auditor` — audit-log requirements for security events.
> - `code-reviewer` — implementation quality of the instrumentation code.

**resilience-auditor**
> - `cost-auditor` — cost-only audits.
> - `observability-expert` — logging / metric instrumentation for resilience signals.
> - `saga-expert` — saga-level compensation patterns.
> - `security-auditor` — auth-related failures and rate-limiting attack paths.
> - `messaging-expert` — idempotency keys and fencing tokens behind retry-safe writes.
> - `runtime-expert` — supervisor, restart policy, retry budgets at the lifecycle layer.
> - `code-reviewer` — broader code quality.

**runtime-expert**
> - `hexagonal-reviewer` — port shapes the runtime composes.
> - `clean-arch-reviewer` — runtime sits in the outermost layer; depends inward only.
> - `ddd-expert` — runtime must not mutate aggregate internals directly; goes through the root.
> - `messaging-expert` — envelope / header / outbox concerns the runtime processes.
> - `event-architect` — events the runtime dispatches.
> - `saga-expert` — distinguishes orchestrator (business flow) from runtime supervisor (process lifetime).
> - `resilience-auditor` — retries, circuit breakers, bulkheads that the runtime configures.
> - `observability-expert` — lifecycle, restart, and pipeline metrics.
> - `code-reviewer` — general code quality.

**saga-expert**
> - `event-architect` — event-schema details for saga events.
> - `ddd-expert` — aggregate correctness for saga participants.
> - `architect-aws-serverless` — Step-Functions / queue plumbing.
> - `messaging-expert` — fencing tokens, idempotency keys, outbox correctness inside saga steps.
> - `runtime-expert` — distinguishes orchestrator (business flow) from runtime supervisor (process lifetime).
> - `resilience-auditor` — retry / circuit-breaker / timeout policy on saga steps.
> - `observability-expert` — correlation ID propagation, saga-state telemetry, DLQ alerts.
> - `code-reviewer` — broader code quality.

**security-auditor**
> - `messaging-expert` — credential / secret value-object redaction (cross-listed; both must catch credential-leak patterns).
> - `contract-reviewer` — auth-related contract surfaces (OAuth scopes, token formats).
> - `architect-aws-serverless` — IAM policies, KMS, secret stores at infrastructure level.
> - `resilience-auditor` — rate limiting and abuse-resistance patterns.
> - `observability-expert` — audit logging and security-event telemetry.
> - `cost-auditor` — cross-account access and cost-attribution implications.
> - `code-reviewer` — broader code quality.

**test-designer**
> - `test-reviewer` — gates the implementation of the test plan.
> - `ddd-expert` — aggregate invariants that should have `audit_*_test.go` style guards.
> - `contract-reviewer` — contract tests for producer / consumer fit.
> - `messaging-expert` — outbox / fencing / envelope tests with documented invariants.
> - `runtime-expert` — lifecycle / supervisor / Plan-Commit tests.
> - `resilience-auditor` — chaos / fault-injection coverage.
> - `security-auditor` — auth and tenant-scope coverage.
> - `code-reviewer` — quality of the test code itself.

**test-reviewer**
> - `test-designer` — upstream author of the test plan.
> - `ddd-expert` — aggregate-invariant coverage (`audit_*_test.go` style).
> - `contract-reviewer` — contract-test coverage for schema changes.
> - `messaging-expert` — outbox / fencing / envelope test coverage.
> - `runtime-expert` — lifecycle / supervisor / Plan-Commit test coverage.
> - `resilience-auditor` — chaos / fault-injection coverage.
> - `security-auditor` — auth and tenant-scope coverage.
> - `code-reviewer` — quality of the test code itself.

**bff-auditor** (`## Collaborators`):
> - `clean-arch-reviewer` — Clean Architecture compliance. · `ddd-expert` — bounded-context alignment. · `api-designer` — REST/GraphQL design upstream of the BFF. · `contract-reviewer` — BFF response schema versioning… · `code-reviewer` — broader code quality.

**clean-arch-reviewer** (`## Collaborators`):
> - `hexagonal-reviewer` — ports/adapters specifics. · `ddd-expert` — aggregate/entity correctness. · `runtime-expert` — composition root… · `messaging-expert` — envelope and transport-type separation… · `code-reviewer` — broader code-quality…

**contract-reviewer** (`## Collaborators`):
> - `event-architect` — event schema design. · `messaging-expert` — envelope / header / idempotency / fencing… · `api-designer` — API surface design upstream… · `code-reviewer`.

**adversarial-reviewer**: no peer list; explicitly isolated: *"You do NOT dispatch sub-agents… You produce one verdict + a structured findings list that `/feature-review` synthesizes."*

**Nature of these handoffs:** they are *peer consult/defer* lists (who owns which concern), not a chain of command. No agent names a superior, an orchestrator, or a human escalation point. The actual orchestration lives in the **skills** (§2).

### 1.2 Rendered v4.15.0 agents vs `plugins/thiink/agents` (diff)

All 25 agents exist in both trees with identical names and bodies. Only difference: in 24 of 25 files the frontmatter `tools:` line is rendered as a YAML list — e.g. `tools: Read, Write, Bash, Grep, Glob` → `tools: [Read, Write, Bash, Grep, Glob]`. `adversarial-reviewer.md` is byte-identical (still **no** `tools`/`model`/`context` frontmatter in the rendered output, so its read-only rule is still unenforced). `observability-expert` still lacks `context: fork`. No agent text, Coordination lists or MCP servers changed.

## 2. Skills — real contents (rendered Claude plugin thiink v4.15.0, `/workspace/thiink/plugin/4.15.0/skills`, 22 SKILL.md)

> Replaces the earlier inferred descriptions. 22 skills: `product-spec, tech-feature, feature-grill-me, feature-ratify, task-split, implement-task, implement-feature, implement-prd, feature-review, diagnose, grill-me, terse, thiink-setup, thiink-sync, synthesize-{architecture,ddd,ubiquitous,adr,aggregate,prd,feature,task}`. `loop` is intentionally absent from the Claude render (Claude has its own `/loop`).

### 2.1 Forward pipeline — phase by phase

```
/product-spec ─PRD (Draft→Grilled→Accepted)─▶ /tech-feature ─F-NNN….in-progress.md─▶ /feature-grill-me ─F….brief.yaml─▶
/feature-ratify ─frozen F-NNN….md + ADRs + UBIQUITOUS rows─▶ /task-split ─T-NN….md + _index.md─▶
/implement-prd ⟶ /implement-feature ⟶ /implement-task (per T; sidecar JSON) ⟶ /feature-review ─F….feature-review.md─▶ feature PR ⟶ ship PR
```

| # | Skill | What it really does | Agents dispatched | Artifacts in → out | Gates (automatic) | Human approval points |
|---|---|---|---|---|---|---|
| 1 | **product-spec** | Author/grill/freeze **one PRD** (`Type: Product` = smallest releasable slice; `Type: Epic` = context only, never built). PRD has *no* APIs/schemas/architecture. Cross-PRD correction ceremony for errors in sibling PRDs. | **None** (grill is host-model with user; QA gate is deterministic) | free-form intent + `--service` or Draft/Grilled PRD → `<service>/docs/prd/PRD-NNN-<slug>.md` (+ attachments dir), appended `UBIQUITOUS.md`, `PERSONAS.md` | `qa-gate.md` Stages A structure (BLOCK), B anti-patterns e.g. "No solution-smuggling" (NITS), C glossary conflicts (BLOCK), D cross-PRD scope; `check-epic-freeze-order.sh` (Epic can't freeze before children unless `--allow-epic-first`) | One grill question per turn; NITS must be fixed/deferred/waived by user; **"Freeze PRD? This makes it immutable…"**; grant ceremony per new term (Approve/Refine/Reject-and-stop); cross-PRD corrections table (Apply all / rows / None); UBIQUITOUS bootstrap offer |
| 2 | **tech-feature** | PRD (Accepted, Product) or free-form intent → 1..N **vertical-slice** F drafts. "Do not write code." Sets `Depends on` and coarse `Owns` globs. | QA gate Stage D required: `doc-markdown-reviewer, clean-arch-reviewer, hexagonal-reviewer, ddd-expert, code-reviewer, test-designer (advisory)`; optional on triggers: `contract-reviewer, security-auditor, event-architect, observability-expert, resilience-auditor, bff-auditor, cost-auditor, saga-expert, messaging-expert, architect-aws-serverless`; plus pre-draft specialist consults | PRD → `docs/features/F-NNN-(PRD-NNN-)?<slug>.in-progress.md` | Stage A (§15 UL coverage), B (14-item completeness, e.g. EC entries, typed Go port signatures), C (decomposition sanity, vertical slice), D agents; "any FAIL vetoes"; 2 auto-redrafts then ask user | Out-of-manifest reads need approval; overlap with existing feature decided with user; per-feature **Confirm/Edit**; never appends UBIQUITOUS (only bootstrap w/ approval) |
| 3 | **feature-grill-me** | Socratic interview on the draft; teaches before each question; lettered options with `A. (Recommended)`. Never mutates the draft. | Optional deep-dive consults, **only at the end, user opt-in** ("Default is None"): `architect-aws-serverless, api-designer, messaging-expert, saga-expert, kpi-architect, ddd-expert, event-architect, security-auditor, observability-expert` (≤500-word notes) | `.in-progress.md` → sibling `F-….brief.yaml` (schema: `reused_terms, banned_synonyms, ddd_shape, hexagonal_direction, design_decisions[], specialist_consults[], new_terms_proposed[], open_questions`) | `check-grill-target.sh`; stop condition (every aggregate boundary unambiguous, every open question has a Default, …) | Every question; consult opt-in; "high-impact choices: ask the user to restate the trade-off" |
| 4 | **feature-ratify** | Freeze ceremony: draft + brief → one frozen F-spec with §17 Provenance; ADRs; granted terms; deletes draft+brief only after frozen file exists. | **Fixed five in parallel:** `ddd-expert, hexagonal-reviewer, clean-arch-reviewer, code-reviewer, contract-reviewer`; **dynamic:** every `brief.specialist_consults[].agent` + triggers → `architect-aws-serverless, api-designer, messaging-expert, saga-expert, kpi-architect` (max one per agent) | `.in-progress.md` + `.brief.yaml` → `F-NNN-….md`, `docs/adr/NNNN-*.md`, UBIQUITOUS rows | `lifecycle-gate.sh`, `scan-arch-corpus.sh`; verdict contract (`## <agent> verdict / Overall: PASS|PASS-WITH-NITS|FAIL / Architectural deltas / Terms / ADR candidates / Other findings`); **3-test ADR gate** (hard-to-reverse AND non-obvious AND had alternatives); failed-gate decisions become deltas | ADR grill one turn each ("No ADR without explicit user approval"); term grill; Reject-and-stop aborts with no writes; **"Freeze <file>? This deletes the in-progress draft and brief."** |
| 5 | **task-split** | Frozen F → `T-NN` tasks, **one DDD/Hex layer per task**, layer order Scaffold→Domain→Ports→Application→Adapters→Documentation; file-ownership matrix (`MERGE-CANDIDATE / SERIAL / PARALLEL-OK`). Never edits parent. | QA gate in parallel: `doc-markdown-reviewer, test-designer, test-reviewer, code-reviewer, clean-arch-reviewer, hexagonal-reviewer, ddd-expert`; add-ons: `contract-reviewer, security-auditor, observability-expert, event-architect, bff-auditor, cost-auditor, saga-expert, messaging-expert, architect-aws-serverless` | `F-NNN-….md` → `docs/tasks/<F-stem>/_index.md` + `T-NN-<F-stem>.md` | `check-split-target.sh`, `scan-split-context.sh` (BLOCK → run /feature-ratify); DAG validity, ID continuity, Parallel-with symmetry; `--max-files-per-task 15` | `MERGE-CANDIDATE` (CREATE+CREATE) **blocks for user choice**; **"Write all <N> task files + _index.md?"** |
| 6 | **implement-task** | Executes exactly one T via a `general-purpose` **runner** sub-agent (runner-prompt.md, Steps 0–11): preflight → dependency check → context gather (≤32 KB bundle) → **TDD red** (test-designer writes failing test) → **green** (implementer) → review (host + diverse model) → bounded fix-loop → verify (`make lint && make test-integration`) → commit → PR → done / escalation. | Red: `test-designer`; optional green consults (max 2): `api-designer, saga-expert, messaging-expert, architect-aws-serverless, kpi-architect`; implementer = task `**Suggested agent:**` else doc writer else **`golang-pro`** else `general-purpose`; reviewers 1–4 by task character (doc → doc-*-reviewer; scaffold → code-reviewer; domain → ddd-expert+code-reviewer; port → hexagonal+clean-arch; adapter → clean-arch+code-reviewer; tests → test-reviewer+code-reviewer; contract → +contract-reviewer), **each mirrored on a diverse model** via `codex-companion.mjs`; fix-loop: `test-designer` test plans, "designer" proposals, fixers; escalation-summarizer | `T-NN….md` → code + `<task>.implement-task.json` sidecar, `.runner-state.json`, BLOCKED → `.decision.md`; commit/PR | Relay protocol: `<!-- IMPLEMENT-TASK-DISPATCH-REQUEST-BEGIN -->{"items":[{"id","kind":"agent|skill|bash","subagent_type",…}]}` / RESPONSE block; `relay_cap = 8 + round_budget*7`; BLOCK codes `tdd-red-failed, tdd-green-failed, reviewer-blocked, ceiling-exceeded, fixer-test-failed, verify-failed, reviewers-unreachable`; final line `<T>: DONE|SKIPPED|BLOCKED — …` | Not interactive by default. **Escalation (Step 11)** writes "ESCALATION: <task_id> — human decision required after <N> review rounds" decision doc with options + recommendation; human may accept `APPROVED_DEGRADED`; mid-run human can inject guidance via state-file `scratch` |
| 7 | **implement-feature** | Wave driver for one frozen F: branch `feat/F-NNN-<slug>`, `compute-waves.sh` from `_index.md`, worktrees, ≤4 parallel tasks per wave (`--sequential` alt), merge done task branches, one feature PR, then **review loop** (`/feature-review`, auto-drain accepted follow-ups ≤2 rounds). | via `/implement-task --commit`; `/feature-review` | `_index.md` → `<task_dir>/.implement-feature.json` sidecar, feature branch, feature PR (no closing keywords), optional per-task PRs | `branch-gate.sh`, `preflight-baseline.sh` (before & after), sidecar commit gate (`git cat-file -e`), `index_sha256` lock; stop_reasons `success, changes-requested, feature-review-blocked, wave-blocked, integration-conflict, pr-failed, baseline-broken, graph-invalid, index-changed…` | `BLOCKED` review → stop: "never auto-resolve Critical items or ADR decisions" |
| 8 | **implement-prd** | PRD-level wave driver: orders frozen+split features (≤2 parallel), calls `/implement-feature --base prd/PRD-NNN-<slug>`, merges feature branches, **cross-feature contract check**, opens one **ship PR** (only PR with `Closes #n`). "never author/decompose". | `/implement-feature`; fresh **`contract-reviewer` + `clean-arch-reviewer`** on merged PRD diff | Accepted Product PRD → `<prd_dir>/.implement-prd.json`, `<prd_dir>/_index.md`, prd branch, ship PR | `build-prd-index.sh` (not-ready unless `--ready-subset`), `compute-waves.sh --unit=feature`, preflight, sidecar gate; stop_reasons incl. `epic-not-implementable, prd-contract-changes-requested, prd-contract-blocked, prd-contract-reviewers-unreachable` | Unreachable contract reviewers only proceed if "explicitly accepted" |
| 9 | **feature-review** | After all T sidecars `done` + integration tests pass: dual-channel review of cumulative diff; buckets approach / cross-task / task-scope / ADR; writes review file and follow-up tasks for accepted Critical/High. | **Always-on (each ×2: host + diverse model):** `adversarial-reviewer, ddd-expert, clean-arch-reviewer, code-reviewer, test-reviewer`; **triggered:** `hexagonal-reviewer, security-auditor, observability-expert, contract-reviewer, bff-auditor, cost-auditor, saga-expert, messaging-expert, architect-aws-serverless` | frozen F + `_index.md` + sidecars + diff → `<F-stem>.feature-review.md`, follow-up `T-NN` + `_index.md` rows, ADRs | Hard blocks: unfinished sidecar, failing `integration_test_command`, **missing `AcceptEC<N>_*` / `// covers: EC<N>` evidence**; canonical schema `== Verdict == / == Findings == / == Approach Challenges == / == Proposed ADRs == / == Rationale ==`; verdict BLOCKED (Critical b1/b2), CHANGES_REQUESTED (High or degraded diverse model), APPROVED; "found nothing" → Medium finding | Interactive: grill each Critical/High and ADR one at a time; ADR files "only after interactive human approval"; headless maps to `Accept-block / Accept-high / Needs-human-ADR-decision`; human may accept degraded review |
| 10 | **diagnose** | Phases 0–6: bind pipeline context (`bind-pipeline-context.sh` git blame → T/F, ECs, Risks, ADRs) → build deterministic feedback loop (10 strategies) → reproduce → 3–5 ranked falsifiable hypotheses → instrument (`[DEBUG-xxxx]` tags) → regression test then fix → cleanup + artifact. | None | report → `docs/diagnoses/<YYYY-MM-DD>-<slug>.md` (Symptom, Repro loop, Hypotheses, Cause, Fix, Regression test, Pipeline context, Architectural follow-up) | "Do not hypothesize without a loop"; no continue until reproduced; mandatory architectural follow-up when no seam / layer leak | Ask for anchor; ask for env access/prod instrumentation if no loop; show ranked hypotheses to user (proceed if unavailable) |
| 11 | **grill-me** | Generic one-question-at-a-time plan stress test; no file output | None | – | stop when next answer wouldn't change plan | every question |
| 12 | **terse** | Concise response mode for gate reviews and agent handoffs | – | – | – | – |
| 13 | **thiink-setup** | Modes audit / triage / bootstrap / tooling / verify of governance scaffold + linters + Makefile | `ddd-expert, clean-arch-reviewer, hexagonal-reviewer, doc-markdown-reviewer, test-designer, golang-pro` | repo → UBIQUITOUS/DDD/ARCHITECTURE/PERSONAS/CONVENTIONS/LINT/TESTS/PLUGIN, ADR-0001, `.golangci.yml`, `.go-arch-lint.yml`, depcruise, Makefile block | verify-citations | seeding/bootstrap choices |

### 2.2 Reverse pipeline (`/thiink-sync` + 8 `synthesize-*` leaves)

`/thiink-sync` is a pure **driver** ("Never author artifacts in the driver"): plans stages `architecture → ddd → ubiquitous → adr → tooling (/thiink-setup) → aggregate (multi-service) → prd → features → tasks`, persists `.thiink-sync.json` sidecar via `sidecar.sh transition`, dispatches one fresh sub-agent per leaf. Leaf contract: `extract → reviewer gate → auto-redraft ≤ N (default 3) → human checkpoint grill → verify-citations → freeze Source: as-built → result envelope`. Because "The human checkpoint cannot run inside a dispatched sub-agent", checkpoint stages split into **Phase A propose** (leaf) → **driver grill** (human, batched lettered A–D) → **Phase B freeze** (leaf). Feature synthesis gated on PRD sidecar `checkpoint.decision == "accepted"`, Confidence ≥ Medium, Type Product. No branch/commit/push.

| Leaf | Reviewer gate agents | Output |
|---|---|---|
| synthesize-architecture | clean-arch-reviewer, hexagonal-reviewer | as-built ARCHITECTURE.md |
| synthesize-ddd | ddd-expert | DDD.md |
| synthesize-ubiquitous | ddd-expert, doc-markdown-reviewer | UBIQUITOUS.md |
| synthesize-adr | adversarial-reviewer | 0..N ADRs (one checkpoint turn per candidate) |
| synthesize-aggregate | ddd-expert, doc-markdown-reviewer | repo-root DDD.md (context map + shared terms) |
| synthesize-prd | adversarial-reviewer | as-built PRD |
| synthesize-feature | adversarial-reviewer, test-reviewer | as-built frozen F-spec |
| synthesize-task | same QA-gate roster as task-split (7 required + 9 add-ons) | born-implemented `_index.md` + T-NN + `done` sidecars (no human checkpoint) |

### 2.3 Handoff formats between phases (summary)

| Boundary | Format |
|---|---|
| PRD → tech-feature | Frozen Markdown PRD (`Status: Accepted`, `Type: Product`, `Epic` backpointer); children cite parents by filename only ("Backwards-only references") |
| tech-feature → grill → ratify | `.in-progress.md` (template §1–§17) + `brief.yaml` schema |
| reviewers → feature-ratify | Markdown verdict contract (`agent-dispatch.md`), sections never omitted, `(none)` when empty |
| task-split → implementers | `_index.md` task list (`Depends on`, `Parallel with`, layer) + file-ownership matrix; T files with `CREATE/UPDATE/DELETE` Files |
| implement-task runner ↔ host | HTML-comment JSON DISPATCH-REQUEST/RESPONSE blocks; final status line |
| task ↔ feature ↔ PRD drivers | JSON sidecars (`task-sidecar.schema.json`, `feature-sidecar.schema.json`, `prd-sidecar.schema.json`) = resume point; `index_sha256` lock |
| reviewers → feature-review | `== Verdict ==` canonical schema with severity + testability + scope; stable IDs `AC-/XT-/TS-/ADR-<hash>` |
| blocked task → human | `escalation-summarizer-template.md` decision doc |
| reverse leaf → driver | result envelope persisted via `sidecar.sh transition` |

### 2.4 Legacy `_dist` skills → owning agent

| Skill | Belongs to |
|---|---|
| create-microservice, create-bounded-context, implement-ddd-aggregate, implement-value-objects, implement-acl | ddd-expert (design) + golang-pro (impl) |
| implement-hexagonal-ports | hexagonal-reviewer / golang-pro |
| create-bff-layer | bff-auditor / api-designer |
| design-event-schema, implement-choreography, implement-event-sourcing, implement-cqrs-pattern | event-architect (+ messaging-expert) |
| implement-saga-orchestration | saga-expert |
| implement-circuit-breaker, implement-stateless-idempotency | resilience-auditor (+ messaging-expert) |
| deployment-aws-serverless-setup, deployment-aws-canary-setup | architect-aws-serverless / DevOps |
| setup-cost-optimization | cost-auditor |
| setup-observability | observability-expert |
| setup-kpi-monitoring | kpi-architect |
| setup-contract-tests | contract-reviewer / test-designer |
| setup-feature-flags | DevOps / CM (no owner) |
| skill-create-test | test-designer + test-reviewer (metadata says `thiink-test-designer`, `thiink-test-reviewer`) |
| skill-asciidoc-documentation | doc-asciidoc-writer/reviewer (metadata says `thiink-doc-writer`, `thiink-doc-reviewer`) |
| frontend-design (claude only) | UI designer / frontend-developer |
| examples: create-lambda-handler | architect-aws-serverless / golang-pro |

## 3. Mapping to the requested minion org (updated from real skill contents)

| Lead minion | Owns skills (real responsibility) | Dispatches / chairs | Gap notes |
|---|---|---|---|
| **CTO coordinator** | `/implement-prd` (ship PR, cross-feature contract check), `/thiink-sync` (reverse pipeline driver) | implement-feature leads; `contract-reviewer` + `clean-arch-reviewer` final PRD check | No persona exists; both skills are pure drivers that "never author" — good fit for a coordinator bot |
| **Project lead** | `/implement-feature` (waves, branches, feature PR, review-drain loop) | Developer minions via `/implement-task`; QA lead via `/feature-review` | No persona; owns stop_reasons/escalations up to CTO |
| **PO** | `/product-spec` (+ `/grill-me`), cross-PRD corrections, term grants at PRD level | **no agents** today; consult kpi-architect for KPIs (suggested add) | Persona missing; human user is the real approver ("Freeze PRD?") |
| **Lead architect** | `/tech-feature`, `/feature-grill-me`, `/feature-ratify`, ADR gate | ddd-expert, hexagonal, clean-arch, code-reviewer, contract-reviewer (+ api-designer, event, saga, messaging, aws, kpi, security, observability consults) | Over-covered specialists; needs one chair persona |
| **Dev lead** | `/task-split` (layer decomposition, ownership matrix), `/implement-task` review/fix-loop policy | task-split QA roster; reviewer selection table in runner Step 5 | `task-split` moved here from "project lead" in v1 — it is a technical decomposition gate |
| **Developer** | `/implement-task` (green stage), `/diagnose` | golang-pro (default implementer); doc writers for doc-only tasks | Only Go; no TS/React implementer; "designer" role referenced but undefined |
| **Tester / QA lead** | `/feature-review` (EC-evidence hard block, adversarial + dual-model), TDD red stage in `/implement-task` | adversarial-reviewer, test-designer, test-reviewer | Strong |
| **DevOps** | `/thiink-setup` (tooling/verify modes), preflight-baseline / `make lint && make test-integration` gates; legacy deployment-aws-* skills | observability-expert, cost-auditor, resilience-auditor | No CI/CD or IaC builder agent |
| **CM** | Branch/worktree/PR scripts inside implement-* (`branch-gate.sh`, `worktree.sh`, `restack.sh`, `open-pr.sh`, `commit-pr-policy.md`), sidecar/`index_sha256` integrity | – | No persona; mechanics fully scripted |
| Designer / UX / UI | none of the 22 skills | – | **Gap unchanged** (only legacy ui-designer, frontend-design) |
| AWS serverless / DynamoDB | consult/trigger agent in grill, ratify, task-split, implement-task, feature-review | architect-aws-serverless | DynamoDB still only a section |
| Analytics | kpi-architect as consult in grill/ratify/implement-task green | – | No analytics/data skill |
| Security | trigger reviewer everywhere | security-auditor | Good |
| Docs | doc-markdown-reviewer in tech-feature/task-split gates; writers for doc-only tasks | doc-* | Good |

**Human-approval points the minion org must preserve** (cannot be delegated to bots without changing the skills): PRD freeze + term grants + cross-PRD corrections; tech-feature Confirm/Edit; grill answers and consult opt-in; ADR approval and F-spec freeze; task-split write confirm and MERGE-CANDIDATE choices; feature-review Critical/High/ADR decisions (headless defers them as `Needs-human-ADR-decision`); acceptance of degraded diverse-model review; implement-task escalation decision docs; thiink-sync checkpoint grills.

## 4. Overlaps

- **Code-review triad:** canonical `code-reviewer` vs `docs/llm/examples/agents/thiink-code-reviewer` vs _dist README's `thiink-clean-arch-reviewer`/`thiink-ddd-expert`. Same for ddd-expert and security-auditor (example + canonical).
- **Envelope boundary:** event-architect vs messaging-expert — resolved explicitly ("this agent owns headers, idempotency, fencing, secret-safety; `event-architect` owns the payload semantics").
- **Credential leaks:** messaging-expert × security-auditor ("cross-listed; both must catch").
- **Orchestrator vs runtime:** saga-expert × runtime-expert (both state the distinction).
- **Telemetry:** observability-expert ↔ kpi-architect ↔ resilience-auditor ↔ cost-auditor — split by concern, clearly stated.
- **Architecture reviewers:** clean-arch + hexagonal + ddd + _dist `thiink-anti-patterns-auditor` + `thiink-microservice-auditor`.
- **_dist duplicates:** mobile-app-developer vs mobile-developer; incident-responder vs devops-incident-responder; debugger vs error-detective; documentation-engineer vs technical-writer vs api-documenter; multi-agent-coordinator vs workflow-orchestrator vs context-manager; devops vs platform vs deployment engineer.
- **Skills:** implement-feature and implement-prd carry duplicate copies of branch-gate/compute-waves/open-pr/restack/worktree/validate-sidecar (intentional self-containment, per `_tests/self_containment_test.sh`). create-microservice / implement-ddd-aggregate exist in both _dist and examples.

## 5. Quality issues

1. ~~Missing skill bodies~~ — resolved using rendered v4.15.0. New skill-level issues: implement-task fix-loop dispatches a "`designer`" role that is **not a defined agent**; product-spec uses **no** agents (PO role is purely user + host model); plugin README says feature-ratify uses "4 review agents" but SKILL.md dispatches a **fixed five** (+ dynamic); `golang-pro` is the only non-doc implementer, so TS/frontend tasks fall to `general-purpose`; `runtime-expert`, `doc-*-writer` (except doc-only tasks), `kpi-architect` (consult only) are rarely/never dispatched by any gate; `resilience-auditor` appears only as a tech-feature add-on.
2. **adversarial-reviewer** has no `tools`/`model`/`context` frontmatter (read-only intent is prose only — not enforced).
3. **observability-expert** lacks `context: fork` (only agent without it).
4. **Least privilege:** every reviewer/auditor declares `Write` (several `Edit`) although they only emit findings.
5. code-reviewer has no H1 title; test-designer has duplicate `## Design process` heading; test-designer/test-reviewer descriptions are one-liners without the corpus clause others have.
6. **Legacy _dist drift:** README says 71 agents, 54 exist; skills reference non-existent `thiink-test-designer`, `thiink-test-reviewer`, `thiink-doc-writer`, `thiink-doc-reviewer`.
7. **Dangling handoffs in _dist agents** (referenced, not defined): backend-developer (27×), sre-engineer (12), security-engineer (11), product-manager (10), fullstack-developer (10), database-administrator (7), data-engineer (7), network-engineer (6), architect-reviewer (6), performance-monitor, error-coordinator, agent-organizer (4 each), task-distributor, legal-advisor, java-architect, tooling-engineer (3), ux-researcher, microservices-architect, compliance-auditor (2), and ~30 singletons (ux-designer, tech-lead, team-lead, project-manager, release-manager, accessibility-tester, postgres-pro, …).
8. _dist agents are generic ~285-line checklists with boilerplate JSON "context-manager" queries (e.g. `"requesting_agent": "devops-engineer"`), not wired to the thiink corpus or pipeline.
9. No agent defines escalation to a human, a superior, or a message format for handoff except the verdict contract in `feature-ratify/agent-dispatch.md` and `/feature-review` — reuse that contract as the minion inter-bot protocol.
10. Canonical stack is Go + AWS only; no TS/React developer or IaC builder among canonical agents.

## 6. Recommendations for the minion org

- Keep the 25 canonical agents as **specialist minions**; reuse their Coordination lists as the peer-routing table.
- Add new **persona minions** that *own skills*: CTO (`/implement-prd`, `/thiink-sync`), Project lead (`/implement-feature`), PO (`/product-spec`, kpi-architect consult), Lead architect (`/tech-feature`, `/feature-grill-me`, `/feature-ratify`; chairs the architecture reviewers), Dev lead (`/task-split`, `/implement-task` review policy, code-reviewer), QA lead (`/feature-review`, test-*), DevOps (`/thiink-setup` tooling, deployment-aws-* skills), CM (branch/worktree/PR scripts, feature flags), UX + UI designer (port `ui-designer`, `frontend-design`), TS/frontend developer, DynamoDB specialist (split out of architect-aws-serverless), Analytics (kpi-architect + data-scientist).
- Adopt the `agent-dispatch.md` verdict contract + `terse` skill as the standard handoff message; add explicit `reports_to` / `escalates_to` fields.
- Retire or rewrite the _dist generic set; fix dangling names by mapping (backend-developer→golang-pro, product-manager→PO, sre-engineer→observability/resilience, etc.).
- See `designs/AGENT_BASED_DEVELOPMENT.md` (orchestrator–worker, DAG waves, judge panels) and `.tmp/OPEN_CLAW.md` / `.tmp/HERMES.md` (multi-agent routing, persistent bots) for the runtime.

## Appendix B — legacy example agents (`docs/llm/examples/agents`)
- thiink-code-reviewer (169 L): "Reviews Go code for Clean Architecture, Hexagonal patterns, testability" — superseded by code-reviewer + clean-arch-reviewer.
- thiink-ddd-expert (175 L) — superseded by ddd-expert.
- thiink-security-auditor (205 L) — superseded by security-auditor.
None defines handoffs.

## Appendix A — _dist/md/cursor/agents (54 generic agents + README), auto-extracted

Identical file set in `_dist/md/claude/agents`. Mostly upstream *awesome-claude-code-subagents* (VoltAgent) personas; 3 legacy `thiink-*` agents. Each generic agent ends with an "Integration with other agents:" block (quoted verbatim below).

### ai-engineer
- Path: `_dist/md/cursor/agents/ai-engineer.md` (286 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert AI engineer specializing in AI system design, model implementation, and production deployment. Masters multiple AI frameworks and tools with focus on building scalable, efficient, and ethical AI solutions from research to production. 
- Handoffs (quoted):
  > Collaborate with data-engineer on data pipelines
  > Support ml-engineer on model deployment
  > Work with llm-architect on language models
  > Guide data-scientist on model selection
  > Help mlops-engineer on infrastructure
  > Assist prompt-engineer on LLM integration
  > Partner with performance-engineer on optimization
  > Coordinate with security-auditor on AI security

### api-documenter
- Path: `_dist/md/cursor/agents/api-documenter.md` (277 lines) · Tools: Read, Write, Edit, Glob, Grep, WebFetch, WebSearch
- Purpose: Expert API documenter specializing in creating comprehensive, developer-friendly API documentation. Masters OpenAPI/Swagger specifications, interactive documentation portals, and documentation automation with focus on clarity, completeness, and exceptional developer experience. 
- Handoffs (quoted):
  > Collaborate with backend-developer on API design
  > Support frontend-developer on integration
  > Work with security-auditor on auth docs
  > Guide qa-expert on testing docs
  > Help devops-engineer on deployment
  > Assist product-manager on features
  > Partner with technical-writer on guides
  > Coordinate with support-engineer on FAQs

### blockchain-developer
- Path: `_dist/md/cursor/agents/blockchain-developer.md` (287 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert blockchain developer specializing in smart contract development, DApp architecture, and DeFi protocols. Masters Solidity, Web3 integration, and blockchain security with focus on building secure, gas-efficient, and innovative decentralized applications. 
- Handoffs (quoted):
  > Collaborate with security-auditor on audits
  > Support frontend-developer on Web3 integration
  > Work with backend-developer on indexing
  > Guide devops-engineer on deployment
  > Help qa-expert on testing strategies
  > Assist architect-reviewer on design
  > Partner with fintech-engineer on DeFi
  > Coordinate with legal-advisor on compliance

### build-engineer
- Path: `_dist/md/cursor/agents/build-engineer.md` (286 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert build engineer specializing in build system optimization, compilation strategies, and developer productivity. Masters modern build tools, caching mechanisms, and creating fast, reliable build pipelines that scale with team growth. 
- Handoffs (quoted):
  > Work with tooling-engineer on build tools
  > Collaborate with dx-optimizer on developer experience
  > Support devops-engineer on CI/CD
  > Guide frontend-developer on bundling
  > Help backend-developer on compilation
  > Assist dependency-manager on packages
  > Partner with refactoring-specialist on code structure
  > Coordinate with performance-engineer on optimization

### cli-developer
- Path: `_dist/md/cursor/agents/cli-developer.md` (286 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert CLI developer specializing in command-line interface design, developer tools, and terminal applications. Masters user experience, cross-platform compatibility, and building efficient CLI tools that developers love to use. 
- Handoffs (quoted):
  > Work with tooling-engineer on developer tools
  > Collaborate with documentation-engineer on CLI docs
  > Support devops-engineer with automation
  > Guide frontend-developer on CLI integration
  > Help build-engineer with build tools
  > Assist backend-developer with CLI APIs
  > Partner with qa-expert on testing
  > Coordinate with product-manager on features

### cloud-architect
- Path: `_dist/md/cursor/agents/cloud-architect.md` (277 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert cloud architect specializing in multi-cloud strategies, scalable architectures, and cost-effective solutions. Masters AWS with focus on security, performance, and compliance while designing resilient cloud-native systems. 
- Handoffs (quoted):
  > Guide devops-engineer on cloud automation
  > Support sre-engineer on reliability patterns
  > Collaborate with security-engineer on cloud security
  > Work with network-engineer on cloud networking
  > Help kubernetes-specialist on container platforms
  > Assist terraform-engineer on IaC patterns
  > Partner with database-administrator on cloud databases
  > Coordinate with platform-engineer on cloud platforms

### context-manager
- Path: `_dist/md/cursor/agents/context-manager.md` (287 lines) · Tools: Read, Write, Edit, Glob, Grep
- Purpose: Expert context manager specializing in information storage, retrieval, and synchronization across multi-agent systems. Masters state management, version control, and data lifecycle with focus on ensuring consistency, accessibility, and performance at scale. 
- Handoffs (quoted):
  > Support agent-organizer with context access
  > Collaborate with multi-agent-coordinator on state
  > Work with workflow-orchestrator on process context
  > Guide task-distributor on workload data
  > Help performance-monitor on metrics storage
  > Assist error-coordinator on error context
  > Partner with knowledge-synthesizer on insights
  > Coordinate with all agents on information needs

### cpp-pro
- Path: `_dist/md/cursor/agents/cpp-pro.md` (276 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert C++ developer specializing in modern C++20/23, systems programming, and high-performance computing. Masters template metaprogramming, zero-overhead abstractions, and low-level optimization with emphasis on safety and efficiency. 
- Handoffs (quoted):
  > Provide C API to python-pro
  > Share performance techniques with rust-engineer
  > Support game-developer with engine code
  > Guide embedded-systems on drivers
  > Collaborate with golang-pro on CGO
  > Work with performance-engineer on optimization
  > Help security-auditor on memory safety
  > Assist java-architect on JNI interfaces

### data-scientist
- Path: `_dist/md/cursor/agents/data-scientist.md` (287 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert data scientist specializing in statistical analysis, machine learning, and business insights. Masters exploratory data analysis, predictive modeling, and data storytelling with focus on delivering actionable insights that drive business value. 
- Handoffs (quoted):
  > Collaborate with data-engineer on data pipelines
  > Support ml-engineer on productionization
  > Work with business-analyst on metrics
  > Guide product-manager on experiments
  > Help ai-engineer on model selection
  > Assist database-optimizer on query optimization
  > Partner with market-researcher on analysis
  > Coordinate with financial-analyst on forecasting

### database-optimizer
- Path: `_dist/md/cursor/agents/database-optimizer.md` (287 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert database optimizer specializing in query optimization, performance tuning, and scalability across multiple database systems. Masters execution plan analysis, index strategies, and system-level optimizations with focus on achieving peak database performance. 
- Handoffs (quoted):
  > Collaborate with backend-developer on query patterns
  > Support data-engineer on ETL optimization
  > Work with postgres-pro on PostgreSQL specifics
  > Guide devops-engineer on infrastructure
  > Help sre-engineer on reliability
  > Assist data-scientist on analytical queries
  > Partner with cloud-architect on cloud databases
  > Coordinate with performance-engineer on system tuning

### debugger
- Path: `_dist/md/cursor/agents/debugger.md` (286 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert debugger specializing in complex issue diagnosis, root cause analysis, and systematic problem-solving. Masters debugging tools, techniques, and methodologies across multiple languages and environments with focus on efficient issue resolution. 
- Handoffs (quoted):
  > Collaborate with error-detective on patterns
  > Support qa-expert with reproduction
  > Work with code-reviewer on fix validation
  > Guide performance-engineer on performance issues
  > Help security-auditor on security bugs
  > Assist backend-developer on backend issues
  > Partner with frontend-developer on UI bugs
  > Coordinate with devops-engineer on production issues

### deployment-engineer
- Path: `_dist/md/cursor/agents/deployment-engineer.md` (285 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert deployment engineer specializing in CI/CD pipelines, release automation, and deployment strategies. Masters blue-green, canary, and rolling deployments with focus on zero-downtime releases and rapid rollback capabilities. 
- Handoffs (quoted):
  > Support devops-engineer with pipeline design
  > Collaborate with sre-engineer on reliability
  > Work with kubernetes-specialist on K8s deployments
  > Guide platform-engineer on deployment platforms
  > Help security-engineer with security integration
  > Assist qa-expert with test automation
  > Partner with cloud-architect on cloud deployments
  > Coordinate with backend-developer on service deployments

### devops-engineer
- Path: `_dist/md/cursor/agents/devops-engineer.md` (284 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert DevOps engineer bridging development and operations with comprehensive automation, monitoring, and infrastructure management. Masters CI/CD, containerization, and cloud platforms with focus on culture, collaboration, and continuous improvement. 
- Handoffs (quoted):
  > Enable deployment-engineer with CI/CD infrastructure
  > Support cloud-architect with automation
  > Collaborate with sre-engineer on reliability
  > Work with kubernetes-specialist on container platforms
  > Help security-engineer with DevSecOps
  > Guide platform-engineer on self-service
  > Partner with database-administrator on database automation
  > Coordinate with network-engineer on network automation

### devops-incident-responder
- Path: `_dist/md/cursor/agents/devops-incident-responder.md` (286 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert incident responder specializing in rapid detection, diagnosis, and resolution of production issues. Masters observability tools, root cause analysis, and automated remediation with focus on minimizing downtime and preventing recurrence. 
- Handoffs (quoted):
  > Collaborate with sre-engineer on reliability
  > Support devops-engineer on monitoring
  > Work with cloud-architect on resilience
  > Guide deployment-engineer on rollbacks
  > Help security-engineer on security incidents
  > Assist platform-engineer on platform stability
  > Partner with network-engineer on network issues
  > Coordinate with database-administrator on data incidents

### documentation-engineer
- Path: `_dist/md/cursor/agents/documentation-engineer.md` (277 lines) · Tools: Read, Write, Edit, Glob, Grep, WebFetch, WebSearch
- Purpose: Expert documentation engineer specializing in technical documentation systems, API documentation, and developer-friendly content. Masters documentation-as-code, automated generation, and creating maintainable documentation that developers actually use. 
- Handoffs (quoted):
  > Work with frontend-developer on UI components
  > Collaborate with api-designer on API docs
  > Support backend-developer with examples
  > Guide technical-writer on content
  > Help devops-engineer with runbooks
  > Assist product-manager with features
  > Partner with qa-expert on testing
  > Coordinate with cli-developer on CLI docs

### embedded-systems
- Path: `_dist/md/cursor/agents/embedded-systems.md` (287 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert embedded systems engineer specializing in microcontroller programming, RTOS development, and hardware optimization. Masters low-level programming, real-time constraints, and resource-limited environments with focus on reliability, efficiency, and hardware-software integration. 
- Handoffs (quoted):
  > Collaborate with iot-engineer on connectivity
  > Support hardware-engineer on interfaces
  > Work with security-auditor on secure boot
  > Guide qa-expert on testing strategies
  > Help devops-engineer on deployment
  > Assist mobile-developer on BLE integration
  > Partner with performance-engineer on optimization
  > Coordinate with architect-reviewer on design

### error-detective
- Path: `_dist/md/cursor/agents/error-detective.md` (287 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert error detective specializing in complex error pattern analysis, correlation, and root cause discovery. Masters distributed system debugging, error tracking, and anomaly detection with focus on finding hidden connections and preventing error cascades. 
- Handoffs (quoted):
  > Collaborate with debugger on specific issues
  > Support qa-expert with test scenarios
  > Work with performance-engineer on performance errors
  > Guide security-auditor on security patterns
  > Help devops-incident-responder on incidents
  > Assist sre-engineer on reliability
  > Partner with monitoring specialists
  > Coordinate with backend-developer on application errors

### frontend-developer
- Path: `_dist/md/cursor/agents/frontend-developer.md` (133 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert UI engineer focused on crafting robust, scalable frontend solutions. Builds high-quality React components prioritizing maintainability, user experience, and web standards compliance. 
- Handoffs (quoted):
  > Receive designs from ui-designer
  > Get API contracts from backend-developer
  > Provide test IDs to qa-expert
  > Share metrics with performance-engineer
  > Coordinate with websocket-engineer for real-time features
  > Work with deployment-engineer on build configs
  > Collaborate with security-auditor on CSP policies
  > Sync with database-optimizer on data fetching

### git-workflow-manager
- Path: `_dist/md/cursor/agents/git-workflow-manager.md` (287 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert Git workflow manager specializing in branching strategies, automation, and team collaboration. Masters Git workflows, merge conflict resolution, and repository management with focus on enabling efficient, clear, and scalable version control practices. 
- Handoffs (quoted):
  > Collaborate with devops-engineer on CI/CD
  > Support release-manager on versioning
  > Work with security-auditor on policies
  > Guide team-lead on workflows
  > Help qa-expert on testing integration
  > Assist documentation-engineer on docs
  > Partner with code-reviewer on standards
  > Coordinate with project-manager on releases

### graphql-architect
- Path: `_dist/md/cursor/agents/graphql-architect.md` (237 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: GraphQL schema architect designing efficient, scalable API graphs. Masters federation, subscriptions, and query optimization while ensuring type safety and developer experience. 
- Handoffs (quoted):
  > Collaborate with backend-developer on resolver implementation
  > Work with api-designer on REST-to-GraphQL migration
  > Coordinate with microservices-architect on service boundaries
  > Partner with frontend-developer on client queries
  > Consult database-optimizer on query efficiency
  > Sync with security-auditor on authorization
  > Engage performance-engineer on optimization
  > Align with fullstack-developer on type sharing

### incident-responder
- Path: `_dist/md/cursor/agents/incident-responder.md` (286 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert incident responder specializing in security and operational incident management. Masters evidence collection, forensic analysis, and coordinated response with focus on minimizing impact and preventing future incidents. 
- Handoffs (quoted):
  > Collaborate with security-engineer on security incidents
  > Support devops-incident-responder on operational issues
  > Work with sre-engineer on reliability incidents
  > Guide cloud-architect on cloud incidents
  > Help network-engineer on network incidents
  > Assist database-administrator on data incidents
  > Partner with compliance-auditor on compliance incidents
  > Coordinate with legal-advisor on legal aspects

### javascript-pro
- Path: `_dist/md/cursor/agents/javascript-pro.md` (276 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert JavaScript developer specializing in modern ES2023+ features, asynchronous programming, and full-stack development. Masters both browser APIs and Node.js ecosystem with emphasis on performance and clean code patterns. 
- Handoffs (quoted):
  > Share modules with typescript-pro
  > Provide APIs to frontend-developer
  > Support react-developer with utilities
  > Guide backend-developer on Node.js
  > Collaborate with webpack-specialist
  > Work with performance-engineer
  > Help security-auditor on vulnerabilities
  > Assist fullstack-developer on patterns

### knowledge-synthesizer
- Path: `_dist/md/cursor/agents/knowledge-synthesizer.md` (287 lines) · Tools: Read, Write, Edit, Glob, Grep
- Purpose: Expert knowledge synthesizer specializing in extracting insights from multi-agent interactions, identifying patterns, and building collective intelligence. Masters cross-agent learning, best practice extraction, and continuous system improvement through knowledge management. 
- Handoffs (quoted):
  > Extract from all agent interactions
  > Collaborate with performance-monitor on metrics
  > Support error-coordinator with failure patterns
  > Guide agent-organizer with team insights
  > Help workflow-orchestrator with process patterns
  > Assist context-manager with knowledge storage
  > Partner with multi-agent-coordinator on optimization
  > Enable all agents with collective intelligence

### kubernetes-specialist
- Path: `_dist/md/cursor/agents/kubernetes-specialist.md` (286 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert Kubernetes specialist mastering container orchestration, cluster management, and cloud-native architectures. Specializes in production-grade deployments, security hardening, and performance optimization with focus on scalability and reliability. 
- Handoffs (quoted):
  > Support devops-engineer with container orchestration
  > Collaborate with cloud-architect on cloud-native design
  > Work with security-engineer on container security
  > Guide platform-engineer on Kubernetes platforms
  > Help sre-engineer with reliability patterns
  > Assist deployment-engineer with K8s deployments
  > Partner with network-engineer on cluster networking
  > Coordinate with terraform-engineer on K8s provisioning

### legacy-modernizer
- Path: `_dist/md/cursor/agents/legacy-modernizer.md` (287 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert legacy system modernizer specializing in incremental migration strategies and risk-free modernization. Masters refactoring patterns, technology updates, and business continuity with focus on transforming legacy systems into modern, maintainable architectures without disrupting operations. 
- Handoffs (quoted):
  > Collaborate with architect-reviewer on design
  > Support refactoring-specialist on code improvements
  > Work with security-auditor on vulnerabilities
  > Guide devops-engineer on deployment
  > Help qa-expert on testing strategies
  > Assist documentation-engineer on docs
  > Partner with database-optimizer on data layer
  > Coordinate with product-manager on priorities

### llm-architect
- Path: `_dist/md/cursor/agents/llm-architect.md` (287 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert LLM architect specializing in large language model architecture, deployment, and optimization. Masters LLM system design, fine-tuning strategies, and production serving with focus on building scalable, efficient, and safe LLM applications. 
- Handoffs (quoted):
  > Collaborate with ai-engineer on model integration
  > Support prompt-engineer on optimization
  > Work with ml-engineer on deployment
  > Guide backend-developer on API design
  > Help data-engineer on data pipelines
  > Assist nlp-engineer on language tasks
  > Partner with cloud-architect on infrastructure
  > Coordinate with security-auditor on safety

### mcp-developer
- Path: `_dist/md/cursor/agents/mcp-developer.md` (275 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert MCP developer specializing in Model Context Protocol server and client development. Masters protocol specification, SDK implementation, and building production-ready integrations between AI systems and external tools/data sources. 
- Handoffs (quoted):
  > Work with api-designer on external API integration
  > Collaborate with tooling-engineer on development tools
  > Support backend-developer with server infrastructure
  > Guide frontend-developer on client integration
  > Help security-engineer with security controls
  > Assist devops-engineer with deployment
  > Partner with documentation-engineer on MCP docs
  > Coordinate with performance-engineer on optimization

### ml-engineer
- Path: `_dist/md/cursor/agents/ml-engineer.md` (287 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert ML engineer specializing in machine learning model lifecycle, production deployment, and ML system optimization. Masters both traditional ML and deep learning with focus on building scalable, reliable ML systems from training to serving. 
- Handoffs (quoted):
  > Collaborate with data-scientist on model development
  > Support data-engineer on feature pipelines
  > Work with mlops-engineer on infrastructure
  > Guide backend-developer on ML APIs
  > Help ai-engineer on deep learning
  > Assist devops-engineer on deployment
  > Partner with performance-engineer on optimization
  > Coordinate with qa-expert on testing

### mlops-engineer
- Path: `_dist/md/cursor/agents/mlops-engineer.md` (286 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert MLOps engineer specializing in ML infrastructure, platform engineering, and operational excellence for machine learning systems. Masters CI/CD for ML, model versioning, and scalable ML platforms with focus on reliability and automation. 
- Handoffs (quoted):
  > Collaborate with ml-engineer on workflows
  > Support data-engineer on data pipelines
  > Work with devops-engineer on infrastructure
  > Guide cloud-architect on cloud strategy
  > Help sre-engineer on reliability
  > Assist security-auditor on compliance
  > Partner with data-scientist on tools
  > Coordinate with ai-engineer on deployment

### mobile-app-developer
- Path: `_dist/md/cursor/agents/mobile-app-developer.md` (286 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert mobile app developer specializing in native and cross-platform development for iOS and Android. Masters performance optimization, platform guidelines, and creating exceptional mobile experiences that users love. 
- Handoffs (quoted):
  > Collaborate with ux-designer on mobile UI
  > Work with backend-developer on APIs
  > Support qa-expert on mobile testing
  > Guide devops-engineer on mobile CI/CD
  > Help product-manager on app features
  > Assist payment-integration on in-app purchases
  > Partner with security-engineer on app security
  > Coordinate with marketing on ASO

### mobile-developer
- Path: `_dist/md/cursor/agents/mobile-developer.md` (283 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Cross-platform mobile specialist building performant native experiences. Creates optimized mobile applications with React Native and Flutter, focusing on platform-specific excellence and battery efficiency. 
- Handoffs (quoted):
  > Coordinate with backend-developer for API optimization and GraphQL/REST design
  > Work with ui-designer for platform-specific designs following HIG/Material Design 3
  > Collaborate with qa-expert on device testing matrix and automation
  > Partner with devops-engineer on build automation and CI/CD pipelines
  > Consult security-auditor on mobile vulnerabilities and OWASP compliance
  > Sync with performance-engineer on optimization and profiling
  > Engage api-designer for mobile-specific endpoints and real-time features
  > Align with fullstack-developer on data sync strategies and offline support

### multi-agent-coordinator
- Path: `_dist/md/cursor/agents/multi-agent-coordinator.md` (287 lines) · Tools: Read, Write, Edit, Glob, Grep
- Purpose: Expert multi-agent coordinator specializing in complex workflow orchestration, inter-agent communication, and distributed system coordination. Masters parallel execution, dependency management, and fault tolerance with focus on achieving seamless collaboration at scale. 
- Handoffs (quoted):
  > Collaborate with agent-organizer on team assembly
  > Support context-manager on state synchronization
  > Work with workflow-orchestrator on process execution
  > Guide task-distributor on work allocation
  > Help performance-monitor on metrics collection
  > Assist error-coordinator on failure handling
  > Partner with knowledge-synthesizer on patterns
  > Coordinate with all agents on communication

### nextjs-developer
- Path: `_dist/md/cursor/agents/nextjs-developer.md` (286 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert Next.js developer mastering Next.js 14+ with App Router and full-stack features. Specializes in server components, server actions, performance optimization, and production deployment with focus on building fast, SEO-friendly applications. 
- Handoffs (quoted):
  > Collaborate with react-specialist on React patterns
  > Support fullstack-developer on full-stack features
  > Work with typescript-pro on type safety
  > Guide database-optimizer on data fetching
  > Help devops-engineer on deployment
  > Assist seo-specialist on SEO implementation
  > Partner with performance-engineer on optimization
  > Coordinate with security-auditor on security

### penetration-tester
- Path: `_dist/md/cursor/agents/penetration-tester.md` (287 lines) · Tools: Read, Grep, Glob, Bash
- Purpose: Expert penetration tester specializing in ethical hacking, vulnerability assessment, and security testing. Masters offensive security techniques, exploit development, and comprehensive security assessments with focus on identifying and validating security weaknesses. 
- Handoffs (quoted):
  > Collaborate with security-auditor on findings
  > Support security-engineer on remediation
  > Work with code-reviewer on secure coding
  > Guide qa-expert on security testing
  > Help devops-engineer on security integration
  > Assist architect-reviewer on security architecture
  > Partner with compliance-auditor on compliance
  > Coordinate with incident-responder on incidents

### performance-engineer
- Path: `_dist/md/cursor/agents/performance-engineer.md` (287 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert performance engineer specializing in system optimization, bottleneck identification, and scalability engineering. Masters performance testing, profiling, and tuning across applications, databases, and infrastructure with focus on achieving optimal response times and resource efficiency. 
- Handoffs (quoted):
  > Collaborate with backend-developer on code optimization
  > Support database-administrator on query tuning
  > Work with devops-engineer on infrastructure
  > Guide architect-reviewer on performance architecture
  > Help qa-expert on performance testing
  > Assist sre-engineer on SLI/SLO definition
  > Partner with cloud-architect on scaling
  > Coordinate with frontend-developer on client performance

### platform-engineer
- Path: `_dist/md/cursor/agents/platform-engineer.md` (287 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert platform engineer specializing in internal developer platforms, self-service infrastructure, and developer experience. Masters platform APIs, GitOps workflows, and golden path templates with focus on empowering developers and accelerating delivery. 
- Handoffs (quoted):
  > Enable devops-engineer with self-service tools
  > Support cloud-architect with platform abstractions
  > Collaborate with sre-engineer on reliability
  > Work with kubernetes-specialist on orchestration
  > Help security-engineer with compliance automation
  > Guide backend-developer with service templates
  > Partner with frontend-developer on UI standards
  > Coordinate with database-administrator on data services

### prompt-engineer
- Path: `_dist/md/cursor/agents/prompt-engineer.md` (287 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert prompt engineer specializing in designing, optimizing, and managing prompts for large language models. Masters prompt architecture, evaluation frameworks, and production prompt systems with focus on reliability, efficiency, and measurable outcomes. 
- Handoffs (quoted):
  > Collaborate with llm-architect on system design
  > Support ai-engineer on LLM integration
  > Work with data-scientist on evaluation
  > Guide backend-developer on API design
  > Help ml-engineer on deployment
  > Assist nlp-engineer on language tasks
  > Partner with product-manager on requirements
  > Coordinate with qa-expert on testing

### python-pro
- Path: `_dist/md/cursor/agents/python-pro.md` (276 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert Python developer specializing in modern Python 3.11+ development with deep expertise in type safety, async programming, data science, and web frameworks. Masters Pythonic patterns while ensuring production-ready code quality. 
- Handoffs (quoted):
  > Provide API endpoints to frontend-developer
  > Share data models with backend-developer
  > Collaborate with data-scientist on ML pipelines
  > Work with devops-engineer on deployment
  > Support fullstack-developer with Python services
  > Assist rust-engineer with Python bindings
  > Help golang-pro with Python microservices
  > Guide typescript-pro on Python API integration

### qa-expert
- Path: `_dist/md/cursor/agents/qa-expert.md` (287 lines) · Tools: Read, Grep, Glob, Bash
- Purpose: Expert QA engineer specializing in comprehensive quality assurance, test strategy, and quality metrics. Masters manual and automated testing, test planning, and quality processes with focus on delivering high-quality software through systematic testing. 
- Handoffs (quoted):
  > Collaborate with test-automator on automation
  > Support code-reviewer on quality standards
  > Work with performance-engineer on performance testing
  > Guide security-auditor on security testing
  > Help backend-developer on API testing
  > Assist frontend-developer on UI testing
  > Partner with product-manager on acceptance criteria
  > Coordinate with devops-engineer on CI/CD

### react-specialist
- Path: `_dist/md/cursor/agents/react-specialist.md` (287 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert React specialist mastering React 18+ with modern patterns and ecosystem. Specializes in performance optimization, advanced hooks, server components, and production-ready architectures with focus on creating scalable, maintainable applications. 
- Handoffs (quoted):
  > Collaborate with frontend-developer on UI patterns
  > Support fullstack-developer on React integration
  > Work with typescript-pro on type safety
  > Guide javascript-pro on modern JavaScript
  > Help performance-engineer on optimization
  > Assist qa-expert on testing strategies
  > Partner with accessibility-specialist on a11y
  > Coordinate with devops-engineer on deployment

### refactoring-specialist
- Path: `_dist/md/cursor/agents/refactoring-specialist.md` (287 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert refactoring specialist mastering safe code transformation techniques and design pattern application. Specializes in improving code structure, reducing complexity, and enhancing maintainability while preserving behavior with focus on systematic, test-driven refactoring. 
- Handoffs (quoted):
  > Collaborate with code-reviewer on standards
  > Support legacy-modernizer on transformations
  > Work with architect-reviewer on design
  > Guide backend-developer on patterns
  > Help qa-expert on test coverage
  > Assist performance-engineer on optimization
  > Partner with documentation-engineer on docs
  > Coordinate with tech-lead on priorities

### rust-engineer
- Path: `_dist/md/cursor/agents/rust-engineer.md` (286 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert Rust developer specializing in systems programming, memory safety, and zero-cost abstractions. Masters ownership patterns, async programming, and performance optimization for mission-critical applications. 
- Handoffs (quoted):
  > Provide FFI bindings to python-pro
  > Share performance techniques with golang-pro
  > Support cpp-developer with Rust/C++ interop
  > Guide java-architect on JNI bindings
  > Collaborate with embedded-systems on drivers
  > Work with wasm-developer on bindings
  > Help security-auditor with memory safety
  > Assist performance-engineer on optimization

### sql-pro
- Path: `_dist/md/cursor/agents/sql-pro.md` (286 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert SQL developer specializing in complex query optimization, database design, and performance tuning across PostgreSQL, MySQL, SQL Server, and Oracle. Masters advanced SQL features, indexing strategies, and data warehousing patterns. 
- Handoffs (quoted):
  > Optimize queries for backend-developer
  > Design schemas with database-optimizer
  > Support data-engineer on ETL
  > Guide python-pro on ORM queries
  > Collaborate with java-architect on JPA
  > Work with performance-engineer on tuning
  > Help devops-engineer on monitoring
  > Assist data-scientist on analytics

### technical-writer
- Path: `_dist/md/cursor/agents/technical-writer.md` (286 lines) · Tools: Read, Write, Edit, Glob, Grep, WebFetch, WebSearch
- Purpose: Expert technical writer specializing in clear, accurate documentation and content creation. Masters API documentation, user guides, and technical content with focus on making complex information accessible and actionable for diverse audiences. 
- Handoffs (quoted):
  > Collaborate with product-manager on features
  > Support developers on API docs
  > Work with ux-researcher on user needs
  > Guide support teams on FAQs
  > Help marketing on content
  > Assist sales-engineer on materials
  > Partner with customer-success on guides
  > Coordinate with legal-advisor on compliance

### terraform-engineer
- Path: `_dist/md/cursor/agents/terraform-engineer.md` (284 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert Terraform engineer specializing in infrastructure as code, multi-cloud provisioning, and modular architecture. Masters Terraform best practices, state management, and enterprise patterns with focus on reusability, security, and automation. 
- Handoffs (quoted):
  > Enable cloud-architect with IaC implementation
  > Support devops-engineer with infrastructure automation
  > Collaborate with security-engineer on secure IaC
  > Work with kubernetes-specialist on K8s provisioning
  > Help platform-engineer with platform IaC
  > Guide sre-engineer on reliability patterns
  > Partner with network-engineer on network IaC
  > Coordinate with database-administrator on database IaC

### test-automator
- Path: `_dist/md/cursor/agents/test-automator.md` (287 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert test automation engineer specializing in building robust test frameworks, CI/CD integration, and comprehensive test coverage. Masters multiple automation tools and frameworks with focus on maintainable, scalable, and efficient automated testing solutions. 
- Handoffs (quoted):
  > Collaborate with qa-expert on test strategy
  > Support devops-engineer on CI/CD integration
  > Work with backend-developer on API testing
  > Guide frontend-developer on UI testing
  > Help performance-engineer on load testing
  > Assist security-auditor on security testing
  > Partner with mobile-developer on mobile testing
  > Coordinate with code-reviewer on test quality

### thiink-anti-patterns-auditor
- Path: `_dist/md/cursor/agents/thiink-anti-patterns-auditor.md` (189 lines) · Tools: (not declared)
- Purpose: Audits code and architecture for common anti-patterns. Identifies violations of Clean Architecture, Hexagonal, and DDD principles. 
- Handoffs: none declared

### thiink-code-interpreter
- Path: `_dist/md/cursor/agents/thiink-code-interpreter.md` (319 lines) · Tools: (not declared)
- Purpose: Transforms code into language-agnostic descriptions using JSON Schema, OpenAPI 3.1, and AsyncAPI 3.0. 
- Handoffs: none declared

### thiink-microservice-auditor
- Path: `_dist/md/cursor/agents/thiink-microservice-auditor.md` (308 lines) · Tools: Read, Grep, Glob
- Purpose: Audits microservice architecture for Thiink. Validates service boundaries, data ownership, communication patterns, and bounded context alignment. 
- Handoffs (quoted):
  > Guide backend-developer on service implementation
  > Coordinate with devops-engineer on deployment
  > Work with security-auditor on zero-trust setup
  > Partner with performance-engineer on optimization
  > Consult database-optimizer on data distribution
  > Sync with api-designer on contract design
  > Collaborate with fullstack-developer on BFF patterns
  > Align with graphql-architect on federation

### typescript-pro
- Path: `_dist/md/cursor/agents/typescript-pro.md` (276 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert TypeScript developer specializing in advanced type system usage, full-stack development, and build optimization. Masters type-safe patterns for both frontend and backend with emphasis on developer experience and runtime safety. 
- Handoffs (quoted):
  > Share types with frontend-developer
  > Provide Node.js types to backend-developer
  > Support react-developer with component types
  > Guide javascript-developer on migration
  > Collaborate with api-designer on contracts
  > Work with fullstack-developer on type sharing
  > Help golang-pro with type mappings
  > Assist rust-engineer with WASM types

### ui-designer
- Path: `_dist/md/cursor/agents/ui-designer.md` (174 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert visual designer specializing in creating intuitive, beautiful, and accessible user interfaces. Masters design systems, interaction patterns, and visual hierarchy to craft exceptional user experiences that balance aesthetics with functionality. 
- Handoffs (quoted):
  > Collaborate with ux-researcher on user insights
  > Provide specs to frontend-developer
  > Work with accessibility-tester on compliance
  > Support product-manager on feature design
  > Guide backend-developer on data visualization
  > Partner with content-marketer on visual content
  > Assist qa-expert with visual testing
  > Coordinate with performance-engineer on optimization

### vue-expert
- Path: `_dist/md/cursor/agents/vue-expert.md` (286 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Expert Vue specialist mastering Vue 3 with Composition API and ecosystem. Specializes in reactivity system, performance optimization, Nuxt 3 development, and enterprise patterns with focus on building elegant, reactive applications. 
- Handoffs (quoted):
  > Collaborate with frontend-developer on UI development
  > Support fullstack-developer on Nuxt integration
  > Work with typescript-pro on type safety
  > Guide javascript-pro on modern JavaScript
  > Help performance-engineer on optimization
  > Assist qa-expert on testing strategies
  > Partner with devops-engineer on deployment
  > Coordinate with database-optimizer on data fetching

### websocket-engineer
- Path: `_dist/md/cursor/agents/websocket-engineer.md` (149 lines) · Tools: Read, Write, Edit, Bash, Glob, Grep
- Purpose: Real-time communication specialist implementing scalable WebSocket architectures. Masters bidirectional protocols, event-driven systems, and low-latency messaging for interactive applications. 
- Handoffs (quoted):
  > Work with backend-developer on API integration
  > Collaborate with frontend-developer on client implementation
  > Partner with microservices-architect on service mesh
  > Coordinate with devops-engineer on deployment
  > Consult performance-engineer on optimization
  > Sync with security-auditor on vulnerabilities
  > Engage mobile-developer for mobile clients
  > Align with fullstack-developer on end-to-end features

### workflow-orchestrator
- Path: `_dist/md/cursor/agents/workflow-orchestrator.md` (287 lines) · Tools: Read, Write, Edit, Glob, Grep
- Purpose: Expert workflow orchestrator specializing in complex process design, state machine implementation, and business process automation. Masters workflow patterns, error compensation, and transaction management with focus on building reliable, flexible, and observable workflow systems. 
- Handoffs (quoted):
  > Collaborate with agent-organizer on process tasks
  > Support multi-agent-coordinator on distributed workflows
  > Work with task-distributor on work allocation
  > Guide context-manager on process state
  > Help performance-monitor on metrics
  > Assist error-coordinator on recovery flows
  > Partner with knowledge-synthesizer on patterns
  > Coordinate with all agents on process execution

