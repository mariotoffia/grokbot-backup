# Spec-to-feature systems and lifecycle agent sources (for teos)
Researched 2026-10-21. All URLs returned HTTP 200 via curl unless noted (tessl-labs/spec-driven-development returned 404 and was dropped).
His pipeline, for reference: PRD → tech spec → grill/clarify → ratify (ADRs) → task split → test-first implementation with multi-model review → feature review → ship PR, with human gates.
Versions and dates come from the issoh.co.jp comparison (checked 2026-10-16). Details marked (secondary) come from comparison articles or memory; I did not read them in the repo.

## Part A: Spec-driven systems

| System | URL | Phases / artifacts | Human gates | Autonomy | Multi-agent | Maturity |
|---|---|---|---|---|---|---|
| GitHub Spec Kit | https://github.com/github/spec-kit | constitution.md → /specify spec.md → /clarify → /plan plan.md (+data-model, contracts, research) → /tasks tasks.md → /implement; v1.2 adds **converge** (diff implementation against spec) | After every stage | Low–medium | No (works with 42 agents) | Established, v1.2.0 (2026-10-13), MIT |
| AWS Kiro specs | https://kiro.dev/docs/specs/ | .kiro/specs/<f>/requirements.md (EARS) → design.md → tasks.md; steering files; hooks | 3 approval gates | Medium (agent hooks, autonomous tasks) | No | Commercial IDE/CLI/Web, Free to $200/mo |
| cc-sdd | https://github.com/gotalab/cc-sdd | /kiro-discovery routing (extend spec / no spec / new spec / multi-spec batch) → requirements (EARS) → design (File Structure Plan) → tasks with _Boundary_/_Depends_ → /kiro-impl (fresh TDD implementer + independent reviewer + 2-round auto-debug per task) → /kiro-validate-impl GO/NO-GO/MANUAL_VERIFY | Between phases, approval state kept in files | High during implementation | Yes (subagents) | Emerging, v3.1.0, solo maintainer |
| OpenSpec | https://github.com/Fission-AI/OpenSpec | changes/<id>/proposal.md + spec deltas (ADDED/MODIFIED/REMOVED) + design.md + tasks.md → apply → **archive merges deltas into openspec/specs/ (living spec, single source of truth)** | Proposal review before apply | Medium | No | Established, 1.14.2 |
| BMAD Method | https://github.com/bmad-code-org/BMAD-METHOD | brief → PRD → UX → architecture → epics/stories → implementation-readiness gate → dev story → code review → retro, with "correct course" | Per document | Medium | Yes (persona agents) | Established, v6.12 stable / v7 |
| Superpowers (obra) | https://github.com/obra/superpowers | brainstorm → design doc (architectural work only) → written plan → subagent-driven TDD execution → code review → finish branch; also systematic debugging skills | Design approval, then plan approval | High (subagent per task + reviewer) | Yes | Very popular, active |
| Agent OS (Builder Methods) | https://github.com/buildermethods/agent-os | standards (product/tech-stack/code-style) → shape-spec → write-spec → create-tasks → implement → verify | Between steps | Medium | Partial (subagents optional) | Emerging/active |
| Taskmaster AI | https://github.com/eyaltoledano/claude-task-master | PRD → parse-prd → tasks.json with dependencies/complexity analysis → expand → next-task loop | Light | Medium | No (MCP tool) | Mature, widely used |
| CCPM (automazeio) | https://github.com/automazeio/ccpm | PRD → epic → decompose → **GitHub Issues sync** → parallel agents in git worktrees → issue progress updates | PRD/epic review | High (parallel) | Yes | Active |
| AWS AI-DLC Workflows | https://github.com/awslabs/aidlc-workflows | AWS "AI-Driven Development Lifecycle": inception (requirements, user stories, units) → construction (domain/logical design, code, tests) → operations; rules for Kiro, Q, and Claude | Explicit approval at each stage, question files | Medium | No | Experimental, AWS-backed; **relevant for teos (DDD + AWS)** |
| GSD (Get Shit Done) | https://github.com/gsd-build/get-shit-done | discuss → research → plan → execute (fresh-context subagents) → verify, by milestone/phase; STATE.md | Light | High | Yes | Emerging, popular |
| spec-workflow-mcp | https://github.com/Pimzino/spec-workflow-mcp | requirements → design → tasks with a dashboard and approval UI | Dashboard approvals | Medium | No | Active |
| Traycer | https://traycer.ai | plan → phases → hand off to the coding agent → verify implementation against plan | Plan review | Medium | Orchestrates external agents | Commercial |
| Tessl | https://tessl.io | Now a skills registry and eval platform; SDD is shipped as an official skill (secondary) | — | — | — | Has pivoted |
| Factory / Devin | https://factory.ai , https://devin.ai | Ticket → plan → autonomous implementation → PR; Droids specialised by task (code, review, incident, knowledge) | PR review | Very high | Factory yes | Commercial |
| MetaGPT | https://github.com/FoundationAgents/MetaGPT | PRD → design → tasks → code → QA via pub/sub SOP | None by default | Full | Yes | Research |
| Others | https://github.com/humanlayer/humanlayer (research → plan → implement prompts, human approvals), https://github.com/coleam00/context-engineering-intro (PRP: product requirement prompts) | | | | | |

Comparison overviews: https://sddobservatory.com/compare/ (tracks 23 frameworks), https://developertoolkit.ai/en/ecosystem/frameworks/spec-driven-frameworks/ , and the KDDI field report https://tech-note.kddi.com/n/nfdc82526fa3b?hl=en (team moved Kiro → cc-sdd → superpowers brainstorming → OpenSpec).

### How his pipeline compares
He is already ahead on: a dedicated grill/clarify step (Spec Kit /clarify and superpowers brainstorming are the closest), ratification via ADRs (most tools have no ADR step), multi-model review (rare; cc-sdd and superpowers use a same-model fresh-context reviewer), and a feature-level review before shipping.
Worth borrowing:
1. **OpenSpec delta + archive → living spec**: after shipping, merge the feature spec into a per-bounded-context system spec so the next PRD starts from the current truth. This is the biggest gap in a per-feature pipeline.
2. **Spec Kit converge / cc-sdd validate-impl**: an automated spec-vs-implementation diff with a GO / NO-GO / MANUAL_VERIFY verdict before the feature review.
3. **Spec Kit constitution**: hard architecture rules (hexagonal ports/adapters, no AWS SDK in domain, OPA policy for every endpoint) checked at the plan stage.
4. **cc-sdd boundaries**: `_Boundary:_`/`_Depends:_` on tasks plus a File Structure Plan. This maps directly to hexagonal layers, and the reviewer flags boundary violations.
5. **cc-sdd discovery routing / superpowers task classification**: route small changes and bugfixes to a light path so the full ceremony only runs on real features.
6. **EARS acceptance criteria** (Kiro/cc-sdd): testable "WHEN…THE SYSTEM SHALL" lines that become the first failing tests.
7. **CCPM GitHub Issues sync + worktree parallelism**: tasks become issues and independent tasks run in parallel worktrees.
8. **Bounded auto-debug** (cc-sdd: 2 rounds, then escalate to a human).
9. **BMAD correct-course and retrospective**: a formal path for when implementation invalidates the spec, and a loop that turns lessons back into the constitution.
10. **AWS AI-DLC**: its DDD unit decomposition and operations phase line up with teos.

## Part B: Lifecycle agent definitions (best sources per stage)
| Stage | Best sources |
|---|---|
| Product discovery / PM | BMAD Analyst (Mary) and PM (John) (research, PRFAQ, PRD); mattpocock/skills (he already knows it); VoltAgent business-product category (product-manager, ux-researcher) https://github.com/VoltAgent/awesome-claude-code-subagents ; contains-studio product (feedback-synthesizer, trend-researcher) https://github.com/contains-studio/agents |
| Architecture | BMAD Architect (Winston); wshobson backend-architect, architect-review, cloud-architect, ddd plugins https://github.com/wshobson/agents ; AWS AI-DLC construction rules; awslabs/mcp (CDK, serverless, DynamoDB, pricing) https://github.com/awslabs/mcp |
| Design / UX / UI | BMAD UX Designer (Sally); contains-studio design (ui-designer, ux-researcher, whimsy); VoltAgent ui-designer |
| Develop | superpowers (TDD, subagent-driven development) https://github.com/obra/superpowers ; cc-sdd /kiro-impl; wshobson golang-pro, typescript/react, backend plugins; VoltAgent golang-pro |
| Test / QA | BMAD Test Architect (TEA) module; wshobson test-automator, tdd-orchestrator; VoltAgent qa-expert |
| Release / DevOps / config | wshobson deployment-engineer, cicd, cloud-infrastructure; VoltAgent devops, deployment, terraform/platform engineers; Factory release flows |
| Bugfix / incident / SRE / observability | superpowers systematic-debugging + root-cause tracing; wshobson incident-response plugin (incident-responder, devops-troubleshooter, error-detective, observability-engineer); VoltAgent sre-engineer, incident-responder; Factory incident Droid pattern |
| Support / customer issues | wshobson customer-support agent; contains-studio studio-operations (support-responder, analytics-reporter); Grok Bot engineering templates (PR/CI triage, VISION.md issue triage) https://groktemplates.dev/categories/engineering |
| Security | wshobson security-auditor, backend-security-coder, threat-modeling plugin; VoltAgent security-auditor, penetration-tester; awslabs/mcp security/well-architected |
| Docs | BMAD Tech Writer (Paige; currently on hiatus); wshobson docs-architect, api-documenter, mermaid; VoltAgent documentation-engineer |
| Analytics | contains-studio analytics-reporter; wshobson data-engineering/analytics plugins |

Recommendation for teos: keep his own pipeline as the backbone. Add the OpenSpec living-spec archive, a Spec Kit-style constitution, cc-sdd boundaries and validation verdicts, and superpowers debugging. Take role prompts from wshobson (the broadest set, works across tools) and BMAD (product, architecture and UX personas). For AWS, ground the agents in awslabs/mcp tools and AI-DLC rules.
Caveat: the agent names inside wshobson, VoltAgent and contains-studio are from secondary sources or memory. The repos load, but check that each agent file exists before you rely on it.
