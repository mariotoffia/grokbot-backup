# TEOS – Minion Team Recommendation

Source: `/workspace/thiink/teos` (binaries/node_modules excluded; `work/` holds git worktrees and benchmark copies of the same tree, so it was ignored for analysis).

## 1. What TEOS is

**Thiink Energy OS**: a multi-tenant, serverless AWS platform for building energy management and IoT integration. It manages buildings and devices, ingests HVAC/BMS sensor data, processes events and alarms (CEP), and sends actuation commands. It integrates with the outside through *providers* grouped by compass direction (`README.md`, `ARCHITECTURE.md`, `AGENTS.md`).

| Area | Evidence |
|---|---|
| Style | Clean/Hexagonal architecture, DDD bounded context per service, policy-as-code (OPA/Rego via `go-core/cbpolicy`), event-driven. Rules enforced by `.go-arch-lint.yml` plus ADRs (`ARCHITECTURE.md`, `AGENTS.md`, `DDD.md`, `UBIQUITOUS.md`) |
| Backend | Go 1.25, AWS SDK v2, ~155k `.go` files including worktrees. Go workspace with `go-core/` (shared libraries), `go-services/` (microservices), `cmd/` (CLIs), `tools/` |
| Core services | `go-services/{appstore,buildingsvc,devicesvc,ingestionsvc,collectorsvc,actuationsvc,eventsvc,corerouter,realestatecore}`, `go-services/core/management/{iam,alarm-service}`, `go-services/core/brokers/gobridge`, `go-services/management/custom/cb-account-creation` |
| Providers | Eastbound: `buildingx, climatixic, danfosslh, ecoguard, mqtt, realestatecore, regin, sensative, sur, tklocal, wideco`. Northbound: `azure, sda, siemens, sma`. Westbound: `algeno, nodabuilding`. Southbound: reserved, none today (`go-services/providers/*`) |
| Analytics | `go-core/cbanalytics`: CEP library with Rego/Go monitors, plans, runtimes, checkpoints, benchmarks (`bench/`), conformance tests, compact storage design (`COMPACT_STORAGE_DESIGN.md`) |
| Pipelines | `go-core/cbpipeline`, `cmd/cbpipeline-schema`, `go-core/providersdk` |
| AWS services | Lambda, API Gateway + Cognito, DynamoDB (one table set per service), EventBridge, SQS, SNS, IoT Core device shadow, S3, CloudWatch, SSM/Secrets Manager, Aurora DSQL, and a Neptune alpha construct (`AGENTS.md`, `ARCHITECTURE.md`, `deployment/`) |
| IaC/deploy | AWS CDK v2 written in Go: `deployment/lib` (core/adapters/cdk), `deployment/stacks/groundzero`. Each service has its own `manifest/manifest.json`. Deployment is manifest-driven with `cbdeploy` (`go-services/appstore/cmd/cbdeploy`, `DEPLOYMENT.md`). Customer products live in `customers/umea-energi/provision-config.yaml` (`CUSTOMER_PRODUCT.md`) |
| Frontends | pnpm monorepo (`pnpm-workspace.yaml`): `web/design/tokens` (@thiink/design-tokens), `web/teos` (cloud admin, React 19, Vite, Tailwind 4/DaisyUI, Zustand, TanStack Query, Vitest), `cmd/tklocal/webui` / `web/tklocal-webui` (on-prem SPA). Design work in `design-in-progess/` (`WEB_DEVELOPMENT.md`) |
| On-prem | `cmd/tklocal`: on-prem agent with server, API spec and WebUI. Uses MQTT/HTTPS eastbound |
| API specs | `meta/spec/{api,model}` (OpenAPI with Redocly, oapi-codegen), `API.md`, `API_ENDPOINT.md`, `API_SECURITY.md` |
| CI/CD | `.github/workflows/{build,lint,archlint,cascade-merge,gobridge-integration}.yml`, CodeQL, Dependabot, secret scanning. Jobs on PRs are label-gated. There are no AWS tests in CI (`TESTS.md`, `GITHUB.md`) |
| Config mgmt | `Makefile` handles module sync and version upgrades. `.cbrepo-locks.json` holds module locks that must be respected even for Dependabot. `cmd/cbrepo`, `CHANGELOG.md`, `BUILD_TAGS.md` |
| Testing | Unit, integration (`integration` tag, Docker emulator or AWS), e2e (`e2e` tag), service tests (`SERVICE_TEST*.md`, `deployment/lib/svctest`, `tests/unit`), testify, `httpmock`, `testutils` |
| Lint/quality | `.golangci.yml`, `.regal` (Rego lint), `cspell.json`, `.prettierrc.json`, `LINT.md` |
| Ops | `devops/{cloudwatch-insights,gh-backup,handlers/devops-clean-table}`, `scripts/{accounts,monitor,migrate-manifest.sh}`, `cmd/{cbmonitor,cblog}`, `docs/KNOWN_DEFECTS_2026-07-29.md` |
| Docs | Antora/AsciiDoc in `documentation/` (architecture, business, products/siemens, projects/{cesab,ume-energi,estimates}, security/nist, sla, servicedesk, roadmap) |
| Existing AI setup | `AGENTS.md`, `.claude/`, `.codex/`, `.playwright-mcp/`, `documentation/ai/onboard-as-a-service`, and many `work/git-worktree/*` feature worktrees, which shows a parallel agent workflow already exists |

## 2. Recommended hierarchy

```
Mario (human)
└── CTO / Coordinator minion
    ├── Product Owner ──(backlog)──> Project Lead
    ├── Chief Architect  (ADRs, arch-lint, DDD)
    │   ├── Software Designer / API Designer (meta/spec)
    │   └── Security & Policy Architect (OPA, Cognito, NIST)
    ├── Project Lead / Delivery (customer projects, releases)
    │   └── Customer Onboarding & Provisioning Engineer
    ├── Development Lead
    │   ├── Core Services Developer(s)
    │   ├── Provider Integration Engineer(s) (east/north/west)
    │   ├── Analytics/CEP Engineer (cbanalytics)
    │   ├── Edge/tklocal Engineer
    │   └── Frontend Developer ── UX/UI Designer (merged)
    ├── QA / Test Lead
    └── Platform Lead (DevOps + IaC + Config Mgmt)
        ├── AWS Serverless & CDK Specialist
        ├── Data Store Specialist (DynamoDB / DSQL)
        └── Release & Configuration Manager
    (Technical Writer is shared and serves everyone)
```

## 3. Roles

| # | Role | Responsibility | Owns (paths) | Key skills | Reports to | Receives from → Hands to |
|---|---|---|---|---|---|---|
| 1 | **CTO / Coordinator** | Routes work, resolves conflicts, assigns worktrees, gives final approval on cross-cutting changes | `AGENTS.md`, `CONVENTIONS.md`, `.claude/`, `.codex/`, `work/git-worktree/` policy | Orchestration, whole-repo context | Mario | Mario's requests → PO, Architect, leads |
| 2 | **Product Owner** | Backlog, acceptance criteria, customer and product requirements, roadmap | `documentation/{roadmap,business,products,sla}`, `CUSTOMER_PRODUCT.md`, `docs/KNOWN_DEFECTS_*.md` | Energy/BMS domain, prioritisation | CTO | Customers, Project Lead → stories to Architect and Dev Lead; acceptance to QA |
| 3 | **Project Lead / Delivery** | Customer projects, estimates, release timing | `documentation/projects/{cesab,ume-energi,estimates}`, `CHANGELOG.md` (with CM) | Planning, estimation | CTO | PO priorities → task breakdown to Dev Lead; release requests to Platform Lead |
| 4 | **Chief Software Architect** | Clean/hex/DDD rules, bounded contexts, ADRs, the `.go-arch-lint.yml` gate, legacy→clean migration plan | `ARCHITECTURE.md`, `DDD.md`, `UBIQUITOUS.md`, `**/_design/`, `**/ARCHITECTURE.md`, `.go-arch-lint.yml`, `go-core/interfaces`, `go-core/tkdisp` | Go architecture, DDD, event-driven AWS | CTO | Stories from PO → designs/ADRs to Designer and Dev Lead; reviews PRs that touch layering |
| 5 | **Software / API Designer** | OpenAPI contracts, data models, event schemas, codegen | `meta/spec/{api,model}`, `API.md`, `API_ENDPOINT.md`, `deployment/schemas`, `cmd/cbgenerate`, `cmd/rectypegen` | OpenAPI, Redocly, oapi-codegen, JSON schema, RealEstateCore | Architect | Architect → specs to developers and Frontend |
| 6 | **Security & Policy Architect** *(missing from list)* | Tenant isolation, Cognito, OPA/Rego policies, API security, NIST mapping, CodeQL/secret triage | `go-core/cbpolicy`, `go-core/cbidentity`, `go-services/core/management/iam`, `API_SECURITY.md`, `documentation/security/nist`, `.regal/`, `cmd/cbiam` | OPA/Rego, IAM, Cognito, threat modelling | Architect (dotted line to CTO) | Designs → policies and reviews; findings to Dev Lead |
| 7 | **Development Lead** | Code standards, PR review, task split, Go module health | `go-core/` (shared libraries), `go-services/Makefile`, `.golangci.yml`, `LINT.md`, `DEVELOPMENT.md` | Go, AWS SDK v2, review | CTO | Tasks from Project Lead and designs from Architect → developers; PRs to QA |
| 8 | **Core Services Developer** (1–2) | Bounded-context services and the shared runtime | `go-services/{appstore,buildingsvc,devicesvc,ingestionsvc,collectorsvc,actuationsvc,eventsvc,corerouter,realestatecore}`, `go-services/core/**`, `go-core/{cbevent,pubsub,managers,cbpipeline,model}` | Go, Lambda handlers, SQS/EventBridge/IoT shadow | Dev Lead | Specs → code and unit tests to QA |
| 9 | **Provider Integration Engineer** *(missing; key domain role)* | Vendor integrations (Siemens, Regin, Danfoss, Ecoguard, Sensative, Azure, SMA, Algeno…), provider SDK | `go-services/providers/**`, `go-core/{provider,providersdk,cbtransport}`, `cmd/cbprov`, `cmd/cbmqtt` | REST/MQTT, BMS/HVAC protocols, vendor APIs | Dev Lead | PO and customer needs → providers and e2e vendor tests to QA |
| 10 | **Analytics / CEP Engineer** (your "analytics" specialist) | CEP engine: monitors, plans, runtime, compact storage, benchmarks | `go-core/cbanalytics/**`, `go-core/cbeval`, `cmd/cbmonitor` | Stream processing, Rego, performance, CBOR | Dev Lead (design via Architect) | Alarm requirements → engine; feeds `alarm-service` |
| 11 | **Edge / tklocal Engineer** *(missing)* | On-prem agent, its server and its install flow | `cmd/tklocal/**` (except webui), `go-services/tklocal`, `go-services/providers/eastbound/tklocal`, `cmd/cblicense` | Go, on-prem networking, MQTT, licensing | Dev Lead | Works with Frontend on `cmd/tklocal/webui` |
| 12 | **Frontend Developer** | TEOS Web and tklocal WebUI | `web/teos`, `web/tklocal-webui`, `cmd/tklocal/webui`, `pnpm-workspace.yaml`, `package.json` | React 19, TS strict, Vite, Tailwind/DaisyUI, Zustand, TanStack Query, Vitest, Playwright | Dev Lead | UI specs from UX/UI and API specs → UI to QA |
| 13 | **UX/UI Designer** (merge UX and UI into one role) | Design system, flows, tokens | `web/design/tokens`, `design-in-progess/`, `WEB_DESIGN.md` refs | Design tokens, accessibility, dashboards | Dev Lead (functionally PO) | PO stories → designs to Frontend |
| 14 | **QA / Test Lead** | Test strategy and the unit/integration/e2e/service-test pyramid; acceptance | `TESTS.md`, `SERVICE_TEST*.md`, `BUILD_TAGS.md`, `tests/`, `deployment/lib/svctest`, `deployment/lib/tests`, `go-services/{testutils,httpmock}`, `cmd/cbtest`, `go-core/cbanalytics/conformance` | testify, Docker emulators, Playwright, build tags | CTO (independent of Dev Lead) | PRs and acceptance criteria → pass/fail to Dev Lead; sign-off to Release Manager |
| 15 | **Platform Lead (DevOps)** | CI workflows, observability, ops tooling, AWS accounts | `.github/`, `devops/**`, `scripts/{accounts,monitor,hooks}`, `cmd/{cblog,cbclean,cbcontrol}` | GitHub Actions, CloudWatch, AWS org/accounts | CTO | Release requests → deploys; incidents to Dev Lead |
| 16 | **AWS Serverless & CDK Specialist** | CDK (Go) stacks, manifests, `cbdeploy`, groundzero bootstrap | `deployment/{lib,stacks,models}`, `**/manifest/manifest.json`, `go-services/appstore/cmd/cbdeploy`, `DEPLOYMENT.md`, `DNS.md`, `go-core/aws`, `go-core/lambdasupport` | CDK v2 Go, Lambda, API GW, Cognito, IoT Core, EventBridge | Platform Lead | Service needs from developers → stacks |
| 17 | **Data Store Specialist** (DynamoDB + DSQL) | Table design, access patterns, migrations, cleanup | `go-services/*/adapters/outbound/dynamodb`, `devops/handlers/devops-clean-table`, `scripts/migrate-manifest.sh`, DSQL baseline code in `appstore` | DynamoDB single-table design, Aurora DSQL, S3 | Platform Lead (design via Architect) | Advises developers |
| 18 | **Release & Configuration Manager** | Versions, module sync and locks, changelog, cascade merges, Dependabot, worktree hygiene | `Makefile`, `.cbrepo-locks.json`, `cmd/cbrepo`, `.github/workflows/cascade-merge.yml`, `CHANGELOG.md`, `**/version.txt`, `tools/go-licenses` | Go workspaces, semver, git | Platform Lead | QA sign-off → tagged release; deploy request to the CDK Specialist |
| 19 | **Customer Onboarding / Provisioning Engineer** *(missing)* | Per-customer product folders, provision configs, overlays | `customers/**`, `deployment/provision-config*.yaml`, `go-services/management/custom/cb-account-creation`, `documentation/ai/onboard-as-a-service` | YAML provisioning, cbdeploy `--product` | Project Lead | PO and customer → config to Platform |
| 20 | **Technical Writer** *(missing; optional)* | Antora site, root docs, spell check | `documentation/**` (antora, asciidoc), `DOCUMENTATION.md`, `cspell.json`, `cmd/cbdoc` | AsciiDoc/Antora, Mermaid | CTO (shared) | Receives from every role |

## 4. Changes to the original list

- **Merge:** UX and UI into one UX/UI Designer. The UI surface is small: one admin dashboard, one on-prem SPA and a token package.
- **Merge:** DevOps and Configuration Management under a Platform Lead. CM is a real need (`.cbrepo-locks.json`, Makefile module sync, cascade-merge), but it should be a sub-role, not a peer.
- **Merge or optional:** Project Lead and Development Lead could be one role at first if you want fewer minions. Keep both if several customer projects run in parallel.
- **Narrow the scope of "AWS serverless" and "DynamoDB" specialists** to the CDK/manifest code and adapter code listed above. Analytics is needed, but it means CEP/stream processing in `go-core/cbanalytics`, not BI or dashboards.
- **Not needed now:** a southbound provider specialist (direction reserved, no code) and a separate mobile developer.
- **Missing and recommended:** Provider Integration Engineer, Security & Policy Architect (OPA/Cognito/multi-tenancy), Edge/tklocal Engineer, Customer Onboarding Engineer, QA Lead as a peer of the Dev Lead, and Technical Writer.
- **Nice to have:** a Legacy Migration minion for moving the flat services (`buildingsvc, actuationsvc, corerouter, ingestionsvc, devicesvc`) to the clean layout described in `ARCHITECTURE.md`.

## 5. Working rules for the minions (from the repo)
- Each minion works in its own `work/git-worktree/<topic>`. The repo already uses this pattern.
- Changes to `.go-arch-lint.yml` need an ADR and the Architect's approval (`AGENTS.md`).
- No one may override `.cbrepo-locks.json` without the CM (`AGENTS.md`).
- CI jobs are label-gated, and integration/e2e tests run locally with credentials (`TESTS.md`). Only QA and Platform minions should hold AWS or vendor credentials.
