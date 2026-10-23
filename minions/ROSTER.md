# Minion roster

Generic software-org team. Every minion is addressed as "<Display name> minion". Bot descriptions: `bot_descriptions/<slug>.md`; full personas: `agents/<slug>.md`. Project specifics come from the target repo's `AGENTS.md`/docs at runtime.

Mario (human)  
└── **cto** (coordinator)  
  ├── **product-owner** (coordinator)  
  │  └── kpi-architect  
  ├── **project-lead** (coordinator)  
  │  └── customer-onboarding  
  ├── **lead-architect** (coordinator)  
  │  ├── api-designer · event-architect · clean-arch-reviewer · hexagonal-reviewer · ddd-reviewer · security-auditor · security-policy  
  ├── **dev-lead** (coordinator)  
  │  ├── golang-pro · typescript-frontend · provider-integration · edge-agent · analytics-cep · ux-ui-designer · code-reviewer  
  ├── **qa-lead** (coordinator)  
  │  ├── test-designer · test-reviewer · adversarial-reviewer  
  ├── **platform-lead** (coordinator)  
  │  ├── aws-serverless-cdk · dynamodb-dsql · observability-sre · cost-auditor · resilience-auditor · release-config-mgr  
  └── technical-writer (shared)

## Display names

| Slug | Display name | Changed? |
|---|---|---|
| cto | CTO minion | — |
| product-owner | Product Owner minion | — |
| project-lead | Project Lead minion | — |
| lead-architect | Chief Software Architect minion | — |
| dev-lead | Development Lead minion | — |
| qa-lead | QA / Test Lead minion | — |
| platform-lead | Platform Lead minion | — |
| kpi-architect | KPI Architect minion | — |
| customer-onboarding | Customer Onboarding Engineer minion | **changed** (was Customer Onboarding & Provisioning Engineer) |
| api-designer | Software / API Designer minion | — |
| event-architect | Event / Messaging Architect minion | — |
| clean-arch-reviewer | Clean Architecture Reviewer minion | — |
| hexagonal-reviewer | Hexagonal Architecture Reviewer minion | — |
| ddd-reviewer | Domain-Driven Design Expert minion | — |
| security-auditor | Security Auditor minion | — |
| security-policy | Security & Policy Architect minion | — |
| golang-pro | Core Services Developer (Go) minion | — |
| typescript-frontend | Frontend Developer minion | — |
| provider-integration | Third-party Integration Engineer minion | **changed** (was Provider Integration Engineer) |
| edge-agent | Edge / On-prem Agent Engineer minion | **changed** (new slug `edge-agent`; old slug was project-specific) |
| analytics-cep | Streaming / CEP Analytics Engineer minion | **changed** (was Analytics / CEP Engineer) |
| ux-ui-designer | UX/UI Designer minion | — |
| code-reviewer | Code Reviewer minion | — |
| test-designer | Test Designer minion | — |
| test-reviewer | Test Reviewer minion | — |
| adversarial-reviewer | Adversarial / Red-team Reviewer minion | — |
| aws-serverless-cdk | AWS Serverless & CDK Specialist minion | — |
| dynamodb-dsql | Data Store Specialist (DynamoDB + DSQL) minion | — |
| observability-sre | Observability / SRE Specialist minion | — |
| cost-auditor | Cost / FinOps Auditor minion | — |
| resilience-auditor | Resilience Auditor minion | — |
| release-config-mgr | Release & Configuration Manager minion | — |
| technical-writer | Technical Writer minion | — |

## Counts
Coordinators 7 · Specialists 26 · **Total 33**

## Branch naming (all implementers)

| Work | Branch |
|---|---|
| PRD integration | `prd/PRD-NNN-<slug>` |
| Feature | `feat/F-NNN-<slug>` |
| Task | `task/F-NNN/T-NN-<slug>` |
| Bug | `fix/W-<id>-<slug>` |
| Hotfix | `hotfix/W-<id>-<slug>` |
| Internal | `chore/W-<id>-<slug>` |

(If the target repo's `AGENTS.md` defines its own branch scheme, it wins.)

## Credentials
Only **qa-lead** and **platform-lead** may hold cloud or third-party credentials. All other minions run with `constraints.no_credentials: true`.

## Backups (watchdog reassignment)

| Primary | Backup |
|---|---|
| cto | product-owner (routing only) / Mario |
| product-owner | cto |
| project-lead | product-owner (status only) / cto |
| lead-architect | clean-arch-reviewer (interim) |
| dev-lead | code-reviewer (interim, no cloud launches) |
| qa-lead | test-reviewer |
| platform-lead | release-config-mgr |
