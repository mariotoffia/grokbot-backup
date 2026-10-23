# Skills allow-list

Source: `skills_allow:` frontmatter in `agents/*.md` (no mapping in README/CONVENTIONS/registry). `/home/box/agent-data/workflows/` does not exist.

| Minion | Allowed skills |
|---|---|
| adversarial-reviewer | `verification-before-completion`, `requesting-code-review` |
| analytics-cep | `test-driven-development`, `verification-before-completion`, `systematic-debugging`, `using-git-worktrees` |
| api-designer | `brainstorming`, `verification-before-completion`, `requesting-code-review` |
| aws-serverless-cdk | `aws-cdk`, `aws-serverless`, `aws-serverless-deployment`, `aws-lambda`, `api-gateway`, `aws-step-functions`, `aws-iam`, `aws-architecture-diagram`, `deploy`, `verification-before-completion` |
| clean-arch-reviewer | `verification-before-completion`, `requesting-code-review` |
| code-reviewer | `requesting-code-review`, `receiving-code-review`, `verification-before-completion` |
| cost-auditor | `aws-billing-and-cost-management`, `verification-before-completion` |
| cto | `dispatching-parallel-agents`, `writing-plans`, `executing-plans`, `verification-before-completion`, `using-superpowers`, `google-drive` |
| customer-onboarding | `verification-before-completion`, `aws-serverless`, `brainstorming` |
| ddd-reviewer | `brainstorming`, `verification-before-completion` |
| dev-lead | `writing-plans`, `executing-plans`, `dispatching-parallel-agents`, `subagent-driven-development`, `test-driven-development`, `using-git-worktrees`, `finishing-a-development-branch`, `requesting-code-review`, `receiving-code-review`, `systematic-debugging`, `verification-before-completion` |
| dynamodb-dsql | `aws-database`, `aws-serverless`, `verification-before-completion`, `brainstorming` |
| edge-agent | `test-driven-development`, `systematic-debugging`, `verification-before-completion`, `using-git-worktrees`, `docker-compose-patterns`, `docker-build-strategies` |
| event-architect | `brainstorming`, `aws-messaging-and-streaming`, `verification-before-completion` |
| golang-pro | `test-driven-development`, `systematic-debugging`, `verification-before-completion`, `using-git-worktrees`, `finishing-a-development-branch`, `requesting-code-review`, `receiving-code-review`, `aws-serverless`, `aws-lambda` |
| hexagonal-reviewer | `verification-before-completion`, `requesting-code-review` |
| kpi-architect | `brainstorming`, `aws-observability`, `verification-before-completion` |
| lead-architect | `brainstorming`, `writing-plans`, `dispatching-parallel-agents`, `requesting-code-review`, `verification-before-completion`, `aws-well-architected-review`, `aws-architecture-diagram` |
| observability-sre | `aws-observability`, `systematic-debugging`, `verification-before-completion`, `aws-lambda` |
| platform-lead | `aws-serverless`, `aws-cdk`, `aws-deployment`, `aws-observability`, `aws-iam`, `aws-security`, `aws-serverless-deployment`, `aws-lambda`, `api-gateway`, `deploy`, `signing-in-to-aws`, `aws-secrets-manager`, `verification-before-completion`, `dispatching-parallel-agents` |
| product-owner | `brainstorming`, `writing-plans`, `google-drive`, `impeccable` |
| project-lead | `writing-plans`, `executing-plans`, `dispatching-parallel-agents`, `verification-before-completion`, `google-drive` |
| provider-integration | `test-driven-development`, `systematic-debugging`, `verification-before-completion`, `using-git-worktrees`, `aws-messaging-and-streaming` |
| qa-lead | `test-driven-development`, `verification-before-completion`, `systematic-debugging`, `requesting-code-review`, `dispatching-parallel-agents` |
| release-config-mgr | `finishing-a-development-branch`, `verification-before-completion`, `using-git-worktrees` |
| resilience-auditor | `aws-serverless`, `aws-messaging-and-streaming`, `verification-before-completion` |
| security-auditor | `aws-security`, `aws-iam`, `aws-secrets-manager`, `verification-before-completion` |
| security-policy | `aws-auth`, `aws-iam`, `aws-security`, `brainstorming`, `verification-before-completion` |
| technical-writer | `brainstorming`, `verification-before-completion`, `impeccable`, `google-drive` |
| test-designer | `test-driven-development`, `verification-before-completion`, `systematic-debugging` |
| test-reviewer | `verification-before-completion`, `requesting-code-review` |
| typescript-frontend | `test-driven-development`, `verification-before-completion`, `using-git-worktrees`, `finishing-a-development-branch`, `impeccable`, `requesting-code-review` |
| ux-ui-designer | `brainstorming`, `impeccable`, `verification-before-completion` |

## Reverse view

| Skill | Minions |
|---|---|
| `api-gateway` | aws-serverless-cdk, platform-lead |
| `aws-architecture-diagram` | aws-serverless-cdk, lead-architect |
| `aws-auth` | security-policy |
| `aws-billing-and-cost-management` | cost-auditor |
| `aws-cdk` | aws-serverless-cdk, platform-lead |
| `aws-database` | dynamodb-dsql |
| `aws-deployment` | platform-lead |
| `aws-iam` | aws-serverless-cdk, platform-lead, security-auditor, security-policy |
| `aws-lambda` | aws-serverless-cdk, golang-pro, observability-sre, platform-lead |
| `aws-messaging-and-streaming` | event-architect, provider-integration, resilience-auditor |
| `aws-observability` | kpi-architect, observability-sre, platform-lead |
| `aws-secrets-manager` | platform-lead, security-auditor |
| `aws-security` | platform-lead, security-auditor, security-policy |
| `aws-serverless` | aws-serverless-cdk, customer-onboarding, dynamodb-dsql, golang-pro, platform-lead, resilience-auditor |
| `aws-serverless-deployment` | aws-serverless-cdk, platform-lead |
| `aws-step-functions` | aws-serverless-cdk |
| `aws-well-architected-review` | lead-architect |
| `brainstorming` | api-designer, customer-onboarding, ddd-reviewer, dynamodb-dsql, event-architect, kpi-architect, lead-architect, product-owner, security-policy, technical-writer, ux-ui-designer |
| `deploy` | aws-serverless-cdk, platform-lead |
| `dispatching-parallel-agents` | cto, dev-lead, lead-architect, platform-lead, project-lead, qa-lead |
| `docker-build-strategies` | edge-agent |
| `docker-compose-patterns` | edge-agent |
| `executing-plans` | cto, dev-lead, project-lead |
| `finishing-a-development-branch` | dev-lead, golang-pro, release-config-mgr, typescript-frontend |
| `google-drive` | cto, product-owner, project-lead, technical-writer |
| `impeccable` | product-owner, technical-writer, typescript-frontend, ux-ui-designer |
| `receiving-code-review` | code-reviewer, dev-lead, golang-pro |
| `requesting-code-review` | adversarial-reviewer, api-designer, clean-arch-reviewer, code-reviewer, dev-lead, golang-pro, hexagonal-reviewer, lead-architect, qa-lead, test-reviewer, typescript-frontend |
| `signing-in-to-aws` | platform-lead |
| `subagent-driven-development` | dev-lead |
| `systematic-debugging` | analytics-cep, dev-lead, edge-agent, golang-pro, observability-sre, provider-integration, qa-lead, test-designer |
| `test-driven-development` | analytics-cep, dev-lead, edge-agent, golang-pro, provider-integration, qa-lead, test-designer, typescript-frontend |
| `using-git-worktrees` | analytics-cep, dev-lead, edge-agent, golang-pro, provider-integration, release-config-mgr, typescript-frontend |
| `using-superpowers` | cto |
| `verification-before-completion` | adversarial-reviewer, analytics-cep, api-designer, aws-serverless-cdk, clean-arch-reviewer, code-reviewer, cost-auditor, cto, customer-onboarding, ddd-reviewer, dev-lead, dynamodb-dsql, edge-agent, event-architect, golang-pro, hexagonal-reviewer, kpi-architect, lead-architect, observability-sre, platform-lead, project-lead, provider-integration, qa-lead, release-config-mgr, resilience-auditor, security-auditor, security-policy, technical-writer, test-designer, test-reviewer, typescript-frontend, ux-ui-designer |
| `writing-plans` | cto, dev-lead, lead-architect, product-owner, project-lead |
