# Web research: AI agent role definitions for a multi-agent software org
Researched 2026-10-21. All URLs below checked with curl (HTTP 200) unless noted.

## 1. BMAD Method — https://github.com/bmad-code-org/BMAD-METHOD (docs: https://docs.bmad-method.org/)
- Covers: named agents tied to phases: Analyst (Mary), PM (John), Architect (Winston), UX Designer (Sally), Developer/Sr Engineer (Amelia), Tech Writer (Paige, on hiatus); PO skill (`bmad-agent-po`) in v7; separate Test Architect (TEA) module. Stable v6.12 (branch V6.12); v7 preview.
- Quality: Very high. Phase-gated (Analysis → Planning → Solutioning → Implementation), "implementation readiness" gate, story files as handoff artifacts.
- Borrow: **artifacts are the handoff** (brief → PRD → architecture → epics/stories → story file → code review → retro); fixed identity plus customizable layer (`_bmad/custom/*.toml`: team overrides + personal `.user.toml`); "persistent facts" loading `project-context.md`; menu codes per agent; "correct course" workflow for when scope changes.

## 2. wshobson/agents — https://github.com/wshobson/agents
- Covers: 202 agents, 185 skills, 105 commands, 94 plugins, 16 orchestrators; runs on Claude Code, Codex, Cursor, OpenCode, Copilot, and others. Includes backend/cloud/k8s/terraform/security/testing/code-review/data/analytics roles and full-stack orchestration commands.
- Quality: High, actively maintained (≈41k stars, MIT). Picks models per tier (strong model for architecture/review, cheaper for routine work).
- Borrow: orchestrator commands that chain agents in sequence (e.g. backend-architect → frontend → test-automator → security-auditor → deployment); one Markdown source converted for each tool; plugin granularity keeps context small.

## 3. VoltAgent/awesome-claude-code-subagents — https://github.com/VoltAgent/awesome-claude-code-subagents
- Covers: 161+ subagents in 10 categories (core dev, language, infra/DevOps, QA & security, data/AI, DX, specialized domains, business/product, **meta & orchestration**: multi-agent-coordinator, workflow-orchestrator, task-distributor, context-manager, agent-organizer). Product-manager, project-manager, ux-researcher, ui-designer, cloud-architect, devops-engineer, qa-expert, database roles.
- Quality: High breadth (≈26k stars, MIT); depth varies. Several agents include a JSON "context query to context-manager" communication protocol.
- Borrow: the meta-orchestration category for CTO/coordinator; structured JSON progress/status messages; a context-manager agent as shared memory.

## 4. Claude Code subagents spec — https://code.claude.com/docs/en/sub-agents
- Covers: official format (YAML frontmatter: name, description, tools, disallowedTools, model, permissionMode, maxTurns, skills, mcpServers, hooks, memory).
- Borrow: least-privilege tool lists per role (e.g. reviewer/tester read-only, no `git push`); "description = when to delegate"; per-agent persistent memory.

## 5. AGENTS.md open standard — https://agents.md
- Covers: repo-level instructions file read by Codex, Cursor, Jules, Copilot, and others: build/test commands, conventions, PR rules. Nested files per package.
- Borrow: one AGENTS.md per repo as the shared contract every role reads; keep role prompts separate.

## 6. MetaGPT — https://github.com/FoundationAgents/MetaGPT (paper: ICLR 2024)
- Covers: PM, Architect, Project Manager, Engineer, QA Engineer driven by SOPs.
- Quality: Foundational research; the clearest handoff design.
- Borrow: **structured documents, not chat** (PRD → system design/file list/interfaces → task list → code → tests); **publish/subscribe message pool** where roles subscribe only to relevant message types; executable feedback loop (QA runs tests and sends failures back to Engineer).

## 7. ChatDev — https://github.com/OpenBMB/ChatDev
- Covers: CEO, CPO, CTO, Programmer, Reviewer, Tester, Art Designer in a waterfall "chat chain" (design → coding → testing → documenting).
- Borrow: pairing in two roles (instructor/assistant) for each phase with explicit termination conditions; CEO/CTO split maps to coordinator vs tech lead; "communicative dehallucination" (assistant asks clarifying questions before acting).

## 8. CrewAI — https://docs.crewai.com/en/concepts/agents
- Covers: role/goal/backstory agents; tasks with `expected_output` and `context` (output of upstream tasks); sequential or hierarchical process with a manager agent; `allow_delegation`.
- Borrow: every handoff has an **expected_output contract**; the hierarchical manager pattern for a CTO/coordinator.

## 9. AWS-specific
- awslabs/mcp — https://github.com/awslabs/mcp : official AWS MCP servers (DynamoDB, Lambda/serverless, CDK, IaC, cost, docs, Bedrock and others). Best tooling base for AWS Serverless and DynamoDB role agents. The DynamoDB data-modeling guidance (access patterns first, single-table design) is good for a DynamoDB specialist prompt.
- awslabs/agent-squad — https://github.com/awslabs/agent-squad : AWS multi-agent orchestrator (classifier routing, supervisor agent, DynamoDB conversation storage). Borrow the intent-classifier/supervisor routing.
- aws-samples/sample-multi-agent-builder-bedrock-crewai — https://github.com/aws-samples/sample-multi-agent-builder-bedrock-crewai : CrewAI on Fargate with agents, missions, and tasks stored in DynamoDB. A reference for keeping agent/task state in DynamoDB.
- awslabs/amazon-bedrock-agentcore-samples — https://github.com/awslabs/amazon-bedrock-agentcore-samples : AgentCore multi-agent samples.
- wshobson and VoltAgent both include cloud-architect, serverless, terraform, and database-optimizer agents. Neither has a strong dedicated DynamoDB agent, so write your own based on the awslabs MCP DynamoDB guidance.

## 10. Cursor rules and other collections
- PatrickJS/awesome-cursorrules — https://github.com/PatrickJS/awesome-cursorrules : mostly tech-stack rules, not roles. Useful for dev-agent coding conventions.
- hesreallyhim/awesome-claude-code — https://github.com/hesreallyhim/awesome-claude-code : curated index of workflows and subagent collections.
- contains-studio/agents — https://github.com/contains-studio/agents : studio-style departments (engineering, design: ui-designer/ux-researcher/brand, product, project-management, testing, studio-operations/analytics). Good for designer/UX/UI/analytics roles.
- zhsama/claude-sub-agent — https://github.com/zhsama/claude-sub-agent : spec-driven workflow (spec-analyst → architect → planner → developer → tester → reviewer) with **quality gates** (score thresholds) between phases.

## 11. Grok Bot templates and shared setups
- Official: https://x.ai/bot/guides/templates-for-grok-bot (templates package instructions, memories, skills, and plugins; no secrets; can be shared with a team or publicly) and https://x.ai/news/team-bots (shared Team Bots with Slack handles and per-user memory).
- Community directories (third-party; vet each one before installing): https://grokbot-templates.com/ (returned HTTP 500 to curl but showed up in search results, so it may be temporarily down), https://groktemplates.dev/categories/engineering (PR triage, CI triage, changelog, "workforce checker" that catches stalled bots, "company with no employees" chief-of-staff + team setup, VISION.md triage), https://grokbotusecases.com/templates/bridge-bot/ (several AI tools sharing one GitHub repo as common memory; asks before pushing).
- Borrow: a chief-of-staff/coordinator bot that spawns workers; a watchdog bot for stalled agents; a shared repo/VISION.md as the source of truth.

## Synthesis: handoff protocol recommendations
1. Handoffs are artifacts (PRD, ADR/architecture, story file, test report), not chat (MetaGPT, BMAD).
2. Every task has an explicit expected_output plus acceptance criteria (CrewAI).
3. Quality gates between phases, such as implementation readiness and review score thresholds (BMAD, zhsama).
4. A coordinator routes work: hierarchical manager or classifier (CrewAI, agent-squad, VoltAgent meta).
5. Roles subscribe only to message types relevant to them (pub/sub) and use a shared context/memory store (MetaGPT, VoltAgent context-manager).
6. Least-privilege tools per role; humans approve merges and deploys (Claude spec, Grok templates).
7. A watchdog/retro loop: catch stalled agents and run an epic retrospective.

## Role mapping (sources to borrow from)
CTO/coordinator: VoltAgent meta, ChatDev CTO, CrewAI manager | Project lead: MetaGPT Project Manager, BMAD sprint planning | Dev lead: wshobson code-reviewer/architect-review | PO/PM: BMAD John/PO, MetaGPT PM | Architect: BMAD Winston | Designer/UX/UI: BMAD Sally, contains-studio design | Developer: BMAD Amelia | Tester: BMAD TEA, VoltAgent qa-expert | DevOps/config mgmt: wshobson/VoltAgent infra (deployment-engineer, terraform) | AWS serverless/DynamoDB: awslabs/mcp plus a custom prompt | Analytics: contains-studio analytics-reporter, wshobson data plugins.
