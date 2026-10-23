# Standalone-minion evaluation: thiink v4.15.0 agents (+ useful legacy ones)

Scope: `/workspace/thiink/plugin/4.15.0/agents` (25 agents), plus `meta/_dist/md/*/agents` and `meta/docs/llm/examples/agents`. "Standalone" means a bot invoked directly by a person or a coordinator minion, with **no** workflow skills (`product-spec`, `tech-feature`, `feature-*`, `task-split`, `implement-*`, `thiink-sync`, `synthesize-*`). Evaluated 2026-10-21.

## 1. Cross-cutting findings (apply to all 25)

| # | Issue | Evidence | Standalone impact | Fix (all agents) |
|---|---|---|---|---|
| X1 | **Governance corpus assumed.** 22/25 read `UBIQUITOUS.md`, `DDD.md`, `ARCHITECTURE.md` (+ optional `CONVENTIONS.md`, `LINT.md`, `PLUGIN.md`, `TESTS.md`, `docs/adr/*`), walking CWD up to repo root. Only clean-arch-reviewer, ddd-expert and runtime-expert say what to do when files are absent. | "Project context — names come from the project's docs" sections | In a repo without these files the agents get no names, and reviewers may report "missing glossary" as findings | Add a shared **"No-corpus mode"** paragraph: if the files are absent, infer names from code, mark them `inferred`, and never fail on a missing file. Optionally offer to draft the files (hand off to doc-markdown-writer). |
| X2 | **`/implement-task` CONTEXT BUNDLE references.** 9 agents: "When invoked via `/implement-task`, the CONTEXT BUNDLE lists `paths.UBIQUITOUS.md`…" (clean-arch, ddd, event, golang-pro, hexagonal, messaging, observability, runtime; test-reviewer uses `paths.feature_path`) | grep | Harmless but confusing, since the condition never fires | Generalise to "If the caller supplies a context bundle or paths, read those first; else discover." |
| X3 | **Verdict vocabulary tied to pipeline gates.** Reviewers emit `== Verdict == APPROVED / CHANGES_REQUESTED / BLOCKED` with severity tags; the gates use PASS/NITS/FAIL in skill wrappers. | "Output format" sections | Fine standalone (a person can read it), but it needs one org-wide schema | Keep `== Verdict ==` as the **standard minion review format** (Verdict, Findings `[sev] file:line - problem. Fix:`, Rationale). Advisors (designers/experts) return a **Design Note** (≤500 words: Context, Options, Recommendation, Risks, Handoffs). |
| X4 | **Over-broad tools.** Every reviewer/auditor has `Write` (several also `Edit`), though they only report. | frontmatter `tools: [Read, Write, Bash, Grep, Glob]` | Risk of unintended edits by "review" bots | Reviewers/auditors: `[Read, Grep, Glob, Bash]` (Bash for linters/tests). Writers/implementers keep Write/Edit. |
| X5 | **`model: inherit` everywhere, `context: fork`** (missing on observability-expert; adversarial-reviewer has no tools/model/context at all) | frontmatter | `inherit` is fine; missing fields break adversarial-reviewer as a bot | Set explicit tiers per minion (e.g. high-reasoning model for architect/adversarial/security; fast model for doc reviewers). Add `context: fork` everywhere. |
| X6 | **Coordination lists name only the 25 thiink agents.** Peer routing is good but has no superior/escalation. | "## Coordination" | Bots can't escalate | Add `reports_to:` and `escalate_when:` (e.g. "BLOCKED or cross-domain conflict → lead architect"). |
| X7 | **Stack bias: Go + AWS + DDD/Hex/Clean.** | golang-pro, test-designer ("Go codebases"), architect-aws-serverless, cost-auditor | OK if the org is Go/AWS; otherwise a gap | State the stack in the description, and add TS/frontend equivalents (see gaps). |
| X8 | **"Thiink" branding/voice.** | doc-* writers ("Thiink voice", `:homepage: www.thiink.com`), several H1 "Thiink … Reviewer" | Brand leakage into other projects | Make voice/branding a parameter (`style guide: <path>`, default "plain, direct, factual"). |

## 2. Per-agent evaluation

Legend. **Verdict** is one of: Ready = usable as-is; Small = ready with small fixes (X1–X5 plus items listed); Rework = needs rework; Merge = merge into another agent; Drop = drop.

| Agent | Verdict | Why | Breaks standalone today (workflow deps) | Concrete fixes | Org role | Direct-invoke input → output |
|---|---|---|---|---|---|---|
| **adversarial-reviewer** | **Rework** | Valuable red-team lens, but written entirely for `/feature-review` | Inputs "F-spec … §17 Provenance", "Task index (`docs/tasks/<F-dir>/_index.md`)", "EC test mapping — `AcceptEC<N>_*`"; "findings list that `/feature-review` synthesizes"; refs `/feature-ratify` and the "3-test gate"; F-spec §1/§11/§15; no tools/model frontmatter | Add frontmatter `tools: [Read, Grep, Glob, Bash]`, `context: fork`, a strong model. Generic inputs: *goal/spec (any format) + diff or paths + test results*. Replace §-refs with "motivation / rejected alternatives / glossary, if provided". Keep the ADR-candidate idea (define the 3-test gate inline). | QA / architecture red team (reports to lead architect & QA lead) | spec or PR description + diff/branch → `== Verdict ==`, Findings, Approach Challenges, ≤3 Proposed ADRs |
| **api-designer** | **Small** | Self-contained REST/GraphQL/OpenAPI/AsyncAPI/Protobuf guidance | Only the corpus (X1) | X1, X3 (Design Note for design mode, Verdict for review mode). Keep Write (it drafts specs). | Architect (API) specialist | requirements or existing API files → OpenAPI/AsyncAPI draft + design note, or review verdict |
| **architect-aws-serverless** | **Small** | Strong; MCP servers `aws-documentation`, `aws-cdk-mcp-server`, `cloudwatch-mcp-server` (the user already has AWS MCPs: Aws-mcp, Awsiac, Awspricing, Aws-serverless-mcp) | Corpus only | Map `mcpServers` to the org's actual servers; X1; drop Write for review mode or split design/review. **Split DynamoDB section into its own specialist** (see gaps). | Specialist: AWS serverless (also platform architect) | workload description / CDK code → architecture design note (services, triggers, IAM, cost hooks) or review verdict |
| **bff-auditor** | **Small** | Narrow but self-contained | Corpus | X1, X4 | Specialist reviewer (frontend-backend boundary); could merge into api-designer if BFF is rare | BFF code paths → verdict + responsibilities matrix |
| **clean-arch-reviewer** | **Small** | Clear BLOCKER triggers; handles missing docs | `/implement-task` bundle line; "BLOCKED is reserved for the four BLOCKER triggers" fine | X2, X4; rename H1 (drop "Thiink"). Consider **merge with hexagonal-reviewer** into one "architecture-conformance reviewer" with two lenses. | Architect / reviewer | diff or package paths → verdict with file:line |
| **code-reviewer** | **Ready** (small X4) | Generic, multi-language, runs linters; Coordination is a good router | none | Keep Edit off for review; add H1. Use as **dev-lead review minion**. | Dev lead (code review gate) | diff/PR → verdict + routed "defer to <agent>" list |
| **contract-reviewer** | **Small** | Generic contract/semver/back-compat rules | "for Thiink" branding | X4, X8 | Architect (contracts) / QA | spec files old+new → compatibility verdict |
| **cost-auditor** | **Small** | Good checklist; MCP cloudwatch | Corpus | X1; wire `user-Awspricing` MCP (`analyze_cdk_project`, `get_pricing`) for real numbers | Platform/FinOps specialist | CDK/IaC or bill/CloudWatch data → cost findings + savings estimate |
| **ddd-expert** | **Small** | Core domain advisor; handles missing corpus | Refers to "skill `tech-feature` §'UBIQUITOUS.md hierarchy'"; `/implement-task` bundle | X2; inline the hierarchy rule; split output into Design Note (modelling) vs Verdict (review) | Architect (domain) — natural **lead-architect deputy** | domain description or code → bounded-context/aggregate model + glossary proposals, or review verdict |
| **doc-asciidoc-reviewer** | **Merge** → doc-reviewer | Same voice rules as markdown reviewer | Thiink toolchain (Antora/Kroki, `_design/`) | Merge both reviewers into one `doc-reviewer` with format modes; parameterise style guide (X8) | Docs / QA | doc files → verdict |
| **doc-asciidoc-writer** | **Merge** → doc-writer | Duplicate voice section | `:homepage: www.thiink.com`, design-system colours, Kroki | Merge with markdown writer; brand as parameter | Tech writer | topic + sources → .adoc/.md file |
| **doc-markdown-reviewer** | **Small** (merge target) | Good GFM + governance-doc checks | governance-file rules | X8 | Docs / QA | .md files → verdict |
| **doc-markdown-writer** | **Small** (merge target) | Owns governance doc formats (useful for bootstrapping corpus, X1) | "Thiink voice" | X8; add "bootstrap UBIQUITOUS/DDD/ARCHITECTURE from code" mode | Tech writer (also corpus keeper) | brief + code paths → doc files |
| **event-architect** | **Small** | Complete event design guidance + schema template | `/implement-task` bundle; corpus | X1, X2, X3 | Architect (events) specialist | domain change → event catalogue/schemas + evolution plan, or review verdict |
| **golang-pro** | **Small** | Only implementer; idiomatic Go, AWS SDK v2 | `/implement-task` bundle; reads CONVENTIONS/LINT | X2; define standalone output: code + tests + "Run: make lint && make test" summary; add a self-check loop (run tests before returning) | Developer (Go) | task description/issue + repo → code changes, tests, change summary |
| **hexagonal-reviewer** | **Small** / Merge candidate | Overlaps clean-arch | bundle line | X2, X4; or merge (see clean-arch) | Architect / reviewer | diff → verdict |
| **kpi-architect** | **Small** | Business KPIs, grafana MCP | Corpus | X1; pair with PO minion | Analytics / PO support | goals/PRD text → KPI table (name, formula, source event, threshold, owner, dashboard) |
| **messaging-expert** | **Small** | Clear ownership vs event-architect | bundle line | X2, X4 | Specialist (messaging/integration) | envelope/outbox code or design → design note / verdict |
| **observability-expert** | **Small** | Strong; grafana + cloudwatch MCP | bundle line; **no `context: fork`** | Add `context: fork`; X2 | Platform/SRE | service code / incident → instrumentation plan or audit verdict |
| **resilience-auditor** | **Small** | Self-contained checklist | Corpus (SLOs) | X1, X4; consider **merge with observability-expert into an "SRE" minion** if headcount matters | Platform/SRE | code calling dependencies → resilience verdict |
| **runtime-expert** | **Small** (niche) | Composition root/plugin registry: very project-specific (`PLUGIN.md`, Plan→Commit) | `PLUGIN.md`, bundle line | X2; generalise language; keep only if the codebase uses plugin registries, else **merge into golang-pro / clean-arch** | Specialist (platform runtime) | `cmd/` / wiring code → verdict |
| **saga-expert** | **Small** | Good orchestration vs choreography guidance | Corpus | X1, X3 | Architect (workflows) | multi-step business flow → saga design (states, compensations, Step Functions sketch) |
| **security-auditor** | **Ready** (X4, X8) | Generic security, IAM examples, no workflow deps | "for Thiink" | Read-only tools; rename | Specialist: Security | code/IaC/policies → security verdict with severity |
| **test-designer** | **Rework** | Two modes are hard-wired to the runner | "round 0, red stage … `/implement-task` Step 4a", "Step 6.6 fix-loop", §Scope/§10 EC, `AcceptEC<N>_` naming, Go-only | Replace the modes with standalone ones: (a) **test plan** for a feature/issue, (b) **write failing test(s)** for a described behaviour; make the EC/acceptance naming a convention, not a requirement; add TS/other languages or rename to `go-test-designer` | QA (test design) | behaviour/spec + code paths → test plan table or failing test file(s) |
| **test-reviewer** | **Small→Rework** | Determinism/flakiness/naming rules are reusable; EC gate is pipeline-specific | "EC coverage gate (mandatory when reviewing tests against an F-spec)", `paths.feature_path`, §10/§10.1 INTEG/BENCH, `tests/_test_index.md` BLOCKER | Make the EC gate conditional on "acceptance criteria supplied (any format)"; demote `_test_index.md` to project convention | QA (test review gate) | test files (+ optional acceptance criteria) → verdict |

### 2.1 Summary count
- Ready as-is (only X4 tool trimming): **code-reviewer, security-auditor** (2)
- Ready with small fixes: **api-designer, architect-aws-serverless, bff-auditor, clean-arch-reviewer, contract-reviewer, cost-auditor, ddd-expert, doc-markdown-reviewer, doc-markdown-writer, event-architect, golang-pro, hexagonal-reviewer, kpi-architect, messaging-expert, observability-expert, resilience-auditor, runtime-expert, saga-expert, test-reviewer** (19)
- Needs rework: **adversarial-reviewer, test-designer** (2)
- Merge: **doc-asciidoc-reviewer → doc-reviewer, doc-asciidoc-writer → doc-writer** (2). Optional merges: hexagonal + clean-arch; resilience + observability → SRE; runtime-expert → golang-pro/clean-arch.
- Drop: none of the 25.

## 3. Useful legacy agents (`meta/_dist`, `meta/docs/llm/examples`)

All are generic VoltAgent-style ~285-line checklists. Their "Integration with other agents" lists point at non-existent agents (e.g. `backend-developer`, `product-manager`), and they include a boilerplate JSON "context-manager" query (`"requesting_agent": ...`) that must be removed.

| Agent | Verdict | Org role | Fixes |
|---|---|---|---|
| typescript-pro, react-specialist (or nextjs-developer) | **Adopt with rework** | Developer (TS/frontend) | Remove context-manager JSON + dangling peers; add corpus-reading + verdict/handoff blocks in thiink style; pick ONE of react/next/vue |
| ui-designer | **Adopt with rework** | Designer (UI) | Same cleanup; output = component spec + design tokens; pair with `frontend-design` skill (claude _dist) |
| frontend-developer | Merge into typescript/react dev | Developer | – |
| devops-engineer + deployment-engineer | **Adopt, merged** into one "platform/devops" minion | Platform/DevOps | Bias to AWS CDK + GitHub Actions; wire Awsiac MCP |
| terraform-engineer, kubernetes-specialist | Optional | Platform specialist | only if stack uses them |
| git-workflow-manager | **Adopt with rework** | CM | Encode branch naming `feat/F-NNN-*`, PR policy, conventional commits |
| multi-agent-coordinator / workflow-orchestrator | **Use as seed** for the CTO/coordinator prompt | CTO/coordinator | Rewrite around the thiink roster + verdict/Design Note contracts |
| qa-expert, test-automator | Optional | QA | Mostly overlap test-designer/reviewer; use test-automator for e2e/Playwright if needed |
| data-scientist, sql-pro, database-optimizer | Optional | Analytics / data | data-scientist pairs with kpi-architect |
| debugger / error-detective | Merge → one "debugger" | Dev / SRE | Use the `diagnose` phases as its built-in method (inline, not as a skill) |
| technical-writer, documentation-engineer, api-documenter | Drop (covered by doc-* minions) | – | – |
| thiink-anti-patterns-auditor, thiink-microservice-auditor, thiink-code-interpreter | Drop / superseded (interpreter optionally useful for code→OpenAPI/AsyncAPI) | – | – |
| examples: thiink-code-reviewer, thiink-ddd-expert, thiink-security-auditor | **Drop** (superseded by canonical) | – | – |
| everything else (blockchain, embedded, cpp, rust, mobile×2, ml/mlops/llm, mcp-developer, cli-developer…) | Drop unless the stack needs it | – | – |

## 4. Recommended standalone roster

| Tier | Minion | Source | Status |
|---|---|---|---|
| Leadership | **CTO / coordinator**: routes requests, fans out to specialists, merges verdicts, escalates to human | NEW (seed from multi-agent-coordinator + agent-dispatch verdict merge rules) | **gap** |
| | **Product owner**: PRD-style requirements, acceptance criteria, scope splitting | NEW (borrow PRD invariants: "no APIs, schemas…"; one releasable slice) | **gap** |
| | **Project / delivery lead**: plans tasks, dependencies, parallel waves, status | NEW (borrow task-split layer ordering + ownership matrix as prose rules) | **gap** |
| | **Lead architect**: chairs ddd/clean-arch/hex/event/saga/api, owns ADRs (3-test gate) | NEW wrapper over ddd-expert | **gap** |
| | **Dev lead**: code-reviewer (+ golang-pro supervision) | code-reviewer | ready |
| | **QA lead**: test-reviewer + adversarial-reviewer | existing (rework) | fix |
| Architecture | ddd-expert, architecture-conformance reviewer (clean-arch + hexagonal), event-architect, messaging-expert, saga-expert, api-designer (+bff lens), contract-reviewer | existing | small fixes |
| Design | **UX designer** (research, flows, personas) | NEW | **gap** |
| | **UI designer** | _dist ui-designer + frontend-design skill | rework |
| Development | golang-pro | existing | small |
| | **TypeScript/React developer** | _dist typescript-pro/react-specialist | rework |
| | debugger (diagnose method inlined) | _dist debugger + diagnose phases | rework |
| QA | test-designer (standalone modes), test-reviewer, adversarial-reviewer | existing | rework/small |
| Platform / DevOps | **platform-devops** (CI/CD, CDK pipelines, environments) | _dist devops+deployment | rework |
| | SRE = observability-expert + resilience-auditor | existing | small |
| | cost-auditor (FinOps) with Awspricing MCP | existing | small |
| CM | **config/change manager** (branches, PR policy, releases, feature flags, changelog) | _dist git-workflow-manager + implement-* commit-pr-policy rules | **gap/rework** |
| Specialists | architect-aws-serverless | existing | small |
| | **DynamoDB specialist** (single-table design, access patterns, GSIs, capacity, streams) | NEW, split from architect-aws-serverless §"DynamoDB design" | **gap** |
| | **Analytics**: kpi-architect + data/analytics engineer (events → warehouse, dashboards) | kpi-architect + NEW data engineer (seed _dist data-scientist) | partial gap |
| | security-auditor | existing | ready |
| | runtime-expert | existing (only if plugin-registry architecture) | optional |
| Docs | doc-writer, doc-reviewer (merged md+adoc) | existing merged | merge |

**Gaps to fill (new prompts needed):** CTO/coordinator, PO, project/delivery lead, lead architect (chair), UX designer, TS/frontend developer, platform/devops builder, CM, DynamoDB specialist, analytics/data engineer. Plus org-wide contracts: the `== Verdict ==` review schema, a ≤500-word Design Note, `reports_to`/`escalate_when`, a no-corpus fallback, and read-only tools for reviewers.
