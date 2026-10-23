# TEOS Minion Skills Inventory

Companion to `design_minion_collaboration.md` v2. Skills are a **shared global library** on Grok Bot. Coordinators name `skills.preferred` / `skills.allow` on each work packet; specialists may only run skills on their allow-list. MCP connectors are listed at the end (not skills).

Legend for role columns: **C** = coordinator preferred; **S** = specialist preferred/allowed; **—** = not on allow-list (coordinator may still attach explicitly for a one-off packet, which temporarily expands allow).

Role abbreviations: CTO, PO, DL (Dev Lead), AR (Lead Architect), QA (QA Lead), PL (Platform Lead), go (golang-pro), fe (typescript-frontend), prov (provider-integration), edge, cep (analytics-cep), td (test-designer), tr (test-reviewer), adv (adversarial-reviewer), cr (code-reviewer), sa (security-auditor), sp (security-policy-architect), ca (clean-arch-reviewer), hx (hexagonal-reviewer), ddd, ev (event-architect), api, ui, ux, cdk (aws-serverless-cdk), data (dynamodb-dsql), obs (observability-sre), cost, res (resilience-auditor), kpi, rel (release-config-mgr), tw (technical-writer), onb (customer-onboarding).

---

## 1. Superpowers (process)

| Skill | Purpose | Who uses it |
|---|---|---|
| `brainstorming` | Explore problem/options before committing; Socratic options | **C:** PO, AR, CTO; **S:** ddd, api, ev, ui, ux, kpi, cdk |
| `writing-plans` | Turn intent into a sequenced plan / packet set | **C:** all coordinators; **S:** — (plans stay with coordinators) |
| `executing-plans` | Drive a written plan step-by-step | **C:** CTO, DL, PL; **S:** — |
| `subagent-driven-development` | Fresh-context sub-work per task (when a bot may spawn helpers) | **C:** DL, AR; **S:** go, fe (inside cloud-agent prompts) |
| `dispatching-parallel-agents` | Fan-out independent packets / cloud agents | **C:** CTO, DL, AR, QA |
| `test-driven-development` | Red → green → refactor | **C:** DL, QA; **S:** go, fe, prov, edge, cep, td |
| `systematic-debugging` | Repro loop → hypotheses → instrument → fix | **C:** DL; **S:** go, obs, cep, edge, prov |
| `verification-before-completion` | Run checks before claiming done | **C:** all; **S:** all implementers + all reviewers |
| `requesting-code-review` | Package a review request (diff, focus, risks) | **C:** DL, AR, QA; **S:** go, fe, cr |
| `receiving-code-review` | Apply or rebut review findings | **C:** DL; **S:** go, fe, prov, edge, cep, cdk |
| `finishing-a-development-branch` | PR hygiene, no force-push, summary, hand back | **C:** DL, PL; **S:** go, fe, rel, tw |
| `using-git-worktrees` | Isolated local checkouts on the shared box | **C:** DL, AR, PL; **S:** go, fe, cdk, tw |
| `writing-skills` | Author/refine skill docs | **C:** CTO; **S:** tw (rare) |
| `using-superpowers` | Meta: when/how to invoke other Superpowers | **C:** all coordinators; **S:** all (thin allow so they can opt into listed process skills) |

---

## 2. AWS core

| Skill | Purpose | Who uses it |
|---|---|---|
| `aws-serverless` | Serverless patterns on AWS | AR, PL, cdk, obs, cost, res |
| `aws-lambda` | Lambda (incl. durable / managed instances / microVMs where covered) | cdk, go, obs, res |
| `api-gateway` | API Gateway design & config | api, cdk, sa, sp |
| `aws-step-functions` | Orchestration / sagas as SFN | cdk, ev, AR, res |
| `aws-serverless-deployment` | Deploy serverless apps | PL, cdk, rel, onb |
| `aws-cdk` | CDK v2 (Go constructs for teos) | cdk, PL, AR, cost |
| `aws-cloudformation` | Raw CFN / template debugging | cdk, PL |
| `aws-database` | DynamoDB, Aurora DSQL, access patterns | data, cdk, AR, go, cost |
| `aws-messaging-and-streaming` | SQS, SNS, EventBridge, Kinesis, IoT | ev, cdk, go, prov, edge, res |
| `aws-observability` | CloudWatch, X-Ray, alarms, insights | obs, PL, res, cost |
| `aws-security` | Security posture across services | sa, sp, PL, AR |
| `aws-iam` | IAM policies, roles, least privilege | sa, sp, cdk, PL |
| `aws-auth` | Cognito / authN patterns | sp, sa, api, fe |
| `aws-secrets-manager` | Secrets & rotation | sa, sp, cdk, PL |
| `aws-billing-and-cost-management` | Cost exploration | cost, PL, CTO |
| `aws-well-architected-review` | WAR lenses | AR, PL, cdk, cost, res, sa |
| `aws-networking` | VPC, endpoints, PrivateLink | PL, cdk, sa |
| `aws-storage` | S3 and related | cdk, data, PL, cost |
| `aws-deployment` | General deploy practices | PL, rel, cdk |
| `aws-compute` | Compute choices beyond Lambda | PL, cdk |
| `aws-containers` | ECS/EKS/container options | PL, edge, cdk |
| `amazon-bedrock` | Bedrock models / agents | AR, PL (rare for teos app) |
| `aws-ai-ml` | Broader AI/ML on AWS | AR, PL (rare) |
| `aws-sdk-js-v3-usage` | JS/TS AWS SDK v3 | fe (BFF/admin only) |
| `signing-in-to-aws` | Auth to AWS for tooling | PL, cdk, obs, onb |
| `launch-with-aws` | Bootstrapping AWS workloads | PL, onb, cdk |
| `aws-architecture-diagram` | Draw architecture diagrams | AR, cdk, tw |
| `deploy` (deploy-on-aws) | Deploy helpers | PL, cdk, rel |
| `elastic-beanstalk` (deploy-on-aws) | EB (unlikely for teos; keep off default allow) | PL only if needed |

---

## 3. AWS AgentCore

| Skill | Purpose | Who uses it |
|---|---|---|
| `agents-get-started` | AgentCore orientation | PL, AR (when building agent runtimes) |
| `agents-build` | Build agents on AgentCore | PL, AR |
| `agents-connect` | Connect tools/channels | PL, AR |
| `agents-deploy` | Deploy agents | PL, rel |
| `agents-harden` | Harden agents | sa, sp, PL |
| `agents-debug` | Debug agent runs | PL, obs |
| `agents-optimize` | Optimize cost/latency | cost, PL |
| `agents-pay` | Billing for agents | cost, PL |

Teos application work rarely needs these; keep on Platform/Architect allow-lists only.

---

## 4. AWS data analytics

| Skill | Purpose | Who uses it |
|---|---|---|
| `amazon-opensearch-service` | OpenSearch | cep, data, obs |
| `redshift-guide` | Redshift | data, cep, cost |
| Data-lake: querying / ingesting / exploring | Lake query & ingest | data, cep |
| MWAA workflow skills | Airflow on AWS | PL, cep (if used) |
| `storing-and-querying-vectors` | Vector stores | data, cep, AR |
| `connecting-to-data-source` | Source connectors | data, cep, prov |
| `creating-data-lake-table` | Table/catalog | data, cep |
| `finding-data-lake-assets` | Discovery | data, cep, tw |

Exact upstream names may vary (`querying-data-lake`, `ingesting-data-lake`, `exploring-data-lake`, `mwaa-*`); map to the closest global-library id when wiring allow-lists.

---

## 5. Docker

| Skill | Purpose | Who uses it |
|---|---|---|
| `docker-project-foundations` | Baseline Docker setup | PL, edge, go, fe |
| `docker-build-strategies` | Efficient/safe builds | PL, edge |
| `docker-compose-patterns` | Compose for local/integration | PL, go, td, edge |
| `docker-destructive-guardrails` | Prevent destructive Docker ops | PL, all implementers (thin) |
| `docker-agent-*` | Agent-oriented Docker helpers | PL |
| `docker-sandboxes-*` | Sandboxed runs | PL, DL |

---

## 6. Other

| Skill | Purpose | Who uses it |
|---|---|---|
| `impeccable` | UI/design polish | ui, ux, fe |
| `google-drive` | Read/write Drive docs | PO, tw, CTO, onb |

---

## 7. Per-role allow-lists (authoritative)

Coordinators may **assign** any skill on a packet; the lists below are what each bot may self-select.

### Coordinators

| Role | Allow-list |
|---|---|
| **CTO** | All Superpowers process; `google-drive`; `aws-billing-and-cost-management`; `aws-well-architected-review`; `aws-architecture-diagram` |
| **PO** | `brainstorming`, `writing-plans`, `verification-before-completion`, `requesting-code-review`, `using-superpowers`, `google-drive`, `impeccable` (for UX review asks) |
| **Dev Lead** | All Superpowers process; `using-git-worktrees`; `docker-compose-patterns`, `docker-destructive-guardrails`, `docker-sandboxes-*` |
| **Lead Architect** | `brainstorming`, `writing-plans`, `dispatching-parallel-agents`, `verification-before-completion`, `requesting-code-review`, `receiving-code-review`, `using-git-worktrees`, `using-superpowers`, `aws-architecture-diagram`, `aws-well-architected-review`, `aws-serverless`, `aws-cdk`, `aws-database`, `aws-messaging-and-streaming`, `aws-security`, AgentCore get-started/build (rare) |
| **QA Lead** | `test-driven-development`, `verification-before-completion`, `requesting-code-review`, `receiving-code-review`, `dispatching-parallel-agents`, `using-superpowers` |
| **Platform Lead** | Superpowers process subset (`writing-plans`, `executing-plans`, `verification-before-completion`, `finishing-a-development-branch`, `using-git-worktrees`, `using-superpowers`); essentially all AWS core + AgentCore + Docker; data-analytics as needed |

### Specialists

| Role | Allow-list |
|---|---|
| **golang-pro** | `test-driven-development`, `systematic-debugging`, `verification-before-completion`, `requesting-code-review`, `receiving-code-review`, `finishing-a-development-branch`, `using-git-worktrees`, `using-superpowers`, `subagent-driven-development`, `aws-lambda`, `aws-messaging-and-streaming`, `aws-database`, `docker-project-foundations`, `docker-compose-patterns`, `docker-destructive-guardrails` |
| **typescript-frontend** | same process set as golang; `impeccable`; `aws-sdk-js-v3-usage`; `aws-auth`; `docker-project-foundations` |
| **provider-integration** | golang process set; `aws-messaging-and-streaming`; `connecting-to-data-source`; `systematic-debugging` |
| **edge-tklocal** | golang process set; `docker-*`; `aws-messaging-and-streaming`; `aws-iot`-via-messaging; `systematic-debugging` |
| **analytics-cep** | golang process set; data-analytics skills; `aws-database`; `aws-messaging-and-streaming`; `amazon-opensearch-service` |
| **test-designer** | `test-driven-development`, `verification-before-completion`, `using-superpowers`, `docker-compose-patterns` |
| **test-reviewer** | `verification-before-completion`, `receiving-code-review`, `requesting-code-review`, `using-superpowers` |
| **adversarial-reviewer** | `verification-before-completion`, `requesting-code-review`, `receiving-code-review`, `brainstorming`, `using-superpowers` |
| **code-reviewer** | `verification-before-completion`, `requesting-code-review`, `receiving-code-review`, `using-superpowers` |
| **security-auditor** | `verification-before-completion`, `aws-security`, `aws-iam`, `aws-auth`, `aws-secrets-manager`, `aws-networking`, `agents-harden`, `using-superpowers` |
| **security-policy-architect** | security-auditor set + `brainstorming`, `writing-plans`, `api-gateway`, `aws-well-architected-review` |
| **clean-arch-reviewer** | `verification-before-completion`, `receiving-code-review`, `using-superpowers` |
| **hexagonal-reviewer** | same as clean-arch |
| **ddd-reviewer** | `brainstorming`, `writing-plans`, `verification-before-completion`, `receiving-code-review`, `using-superpowers` |
| **event-architect** | `brainstorming`, `writing-plans`, `verification-before-completion`, `aws-messaging-and-streaming`, `aws-step-functions`, `using-superpowers` |
| **api-designer** | `brainstorming`, `writing-plans`, `verification-before-completion`, `api-gateway`, `aws-auth`, `using-superpowers` |
| **ui-designer** | `brainstorming`, `impeccable`, `verification-before-completion`, `using-superpowers` |
| **ux-designer** | `brainstorming`, `impeccable`, `writing-plans`, `using-superpowers`, `google-drive` |
| **aws-serverless-cdk** | `aws-serverless`, `aws-lambda`, `api-gateway`, `aws-step-functions`, `aws-serverless-deployment`, `aws-cdk`, `aws-cloudformation`, `aws-database`, `aws-messaging-and-streaming`, `aws-iam`, `aws-secrets-manager`, `aws-networking`, `aws-storage`, `aws-deployment`, `aws-compute`, `aws-containers`, `aws-architecture-diagram`, `aws-well-architected-review`, `deploy`, `signing-in-to-aws`, `launch-with-aws`, process: `verification-before-completion`, `finishing-a-development-branch`, `using-git-worktrees`, `receiving-code-review`, `using-superpowers` |
| **dynamodb-dsql** | `aws-database`, `aws-storage`, data-lake/vector skills as needed, `aws-billing-and-cost-management`, `brainstorming`, `verification-before-completion`, `using-superpowers` |
| **observability-sre** | `aws-observability`, `systematic-debugging`, `verification-before-completion`, `aws-lambda`, `aws-messaging-and-streaming`, `agents-debug`, `using-superpowers` |
| **cost-auditor** | `aws-billing-and-cost-management`, `aws-well-architected-review`, `aws-cdk`, `aws-database`, `aws-storage`, `agents-optimize`, `agents-pay`, `verification-before-completion`, `using-superpowers` |
| **resilience-auditor** | `aws-serverless`, `aws-lambda`, `aws-messaging-and-streaming`, `aws-step-functions`, `aws-well-architected-review`, `verification-before-completion`, `using-superpowers` |
| **kpi-architect** | `brainstorming`, `writing-plans`, `aws-observability`, `using-superpowers`, `google-drive` |
| **release-config-mgr** | `finishing-a-development-branch`, `verification-before-completion`, `aws-deployment`, `aws-serverless-deployment`, `deploy`, `using-git-worktrees`, `using-superpowers` |
| **technical-writer** | `writing-plans`, `verification-before-completion`, `finishing-a-development-branch`, `using-git-worktrees`, `aws-architecture-diagram`, `google-drive`, `using-superpowers`, `writing-skills` |
| **customer-onboarding** | `aws-serverless-deployment`, `launch-with-aws`, `signing-in-to-aws`, `deploy`, `verification-before-completion`, `google-drive`, `using-superpowers` |

---

## 8. MCP connectors (not skills)

Attach per bot; do not put in `skills:` on packets.

| Connector | Attach to |
|---|---|
| Gmail | CTO, PO (notifications only; no autonomous send without Mario approval) |
| Google Drive | PO, tw, CTO, onb |
| Awsknowledge | AR, PL, cdk, data, obs, cost, sa |
| Awsiac | cdk, PL, AR, cost |
| Awspricing | cost, PL, cdk |
| Aws-mcp | PL, cdk, obs, sa, data |
| Aws-serverless-mcp | cdk, PL, AR |
| Origin (Cursor Origin) | DL, CTO (cloud agent / PR status if applicable) |
| GitHub MCP | DL, PL, rel — **after auth**; until then use cloud agents for PRs |

---

## 9. Packet skill selection rules

1. Coordinator always sets `skills.preferred` (1–3) and `skills.allow` (subset of the specialist's allow-list).
2. Specialist runs preferred first; may add from allow if needed; must not run anything outside allow.
3. Process skills that change repo state (`finishing-a-development-branch`, `using-git-worktrees`) are only for implementer / release packets.
4. Reviewer packets get `verification-before-completion` + `receiving-code-review` only — never TDD or deploy skills.
5. If a needed skill is missing from the allow-list, specialist returns `blocked: need-skill` naming it; coordinator expands the packet or reassigns.
