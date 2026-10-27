# Conventions (recipes and standards)

MUST rules live in [README.md](README.md). The target repo's `AGENTS.md` wins on project details; report drift to the technical-writer minion.

## §0 Ground rules
- **Board-only scope (Mario, 2026-10-27):** minions touch nothing that is not on BOARD.md, and only Mario approves additions to the board.
- **KISS, less is more (Mario, standing rule for every minion).** Don't overcomplicate. Make it dead simple and hard to do wrong. Don't fix what isn't broken. Keep diffs minimal, add no new machinery unless something can't work without it, and drop Low findings instead of running extra rounds.
- **Latest everywhere.** Generators and tools track latest, and GitHub Actions use major tags (`@v4`). Pin only temporarily after a serious breakage.
- **No parallel make in the same worktree,** so add no locks for it.
- DDD + hexagonal + clean architecture. Exceptions need an ADR.
- Dependencies point inward: adapters → application → domain. Domain imports no framework, SDK, transport or persistence.
- The core owns ports; adapters implement them and stay thin. Only the composition root (`cmd/`, `main`) wires.
- Use the context's ubiquitous language. Map third-party models in an anti-corruption layer.
- Data changes additive; schema/key changes are always-gates.
- Keep files near 600 lines; split, don't cut.
- Code comments say what the code is. No task ids, hashes or history.
- Plain English. Conventional commits. No secrets anywhere.

## §1 Quality gates
Done only when every gate for each touched language is green. Put commands + results in the `done` reply. A failing gate is `blocked: verify-failed`. Prefer repo make/npm targets.

| Gate | Go | TS / web | Other |
|---|---|---|---|
| Format | `gofmt`/`goimports` | Prettier | formatter |
| **Linter** | `golangci-lint run` | ESLint `--max-warnings=0` | ruff, clippy, ktlint… |
| **Arch-lint** | `go-arch-lint check` | eslint-plugin-boundaries / dependency-cruiser | import-linter, ArchUnit… |
| Vet / types | `go vet` | `tsc --noEmit` | type checker |
| Unit | `go test` (no Docker/cloud) | Vitest/Jest | — |
| Integration | build-tagged, local emulators | Playwright | — |
| Deps | `go mod tidy` clean diff | lockfile clean | — |

Never disable a rule inline without a justification comment and reviewer approval. Never weaken arch-lint to pass. Arch-lint config changes need an ADR + Lead Architect approval.

## §2 Layout
```text
<service>/
  domain/        # aggregates, entities, value objects, events (pure)
  application/   # use cases, port interfaces
  adapters/inbound/  adapters/outbound/
  cmd/ | main    # composition root
```
Go: `internal/core/{domain,ports,services}` + `internal/adapters/...`. TS: `src/{domain,application,adapters}`. Use the repo's spelling.

## §3 Docs locality
Each service keeps `DDD.md`, `UBIQUITOUS.md`, `ARCHITECTURE.md`, `LINT.md`, `adr/`, `plans/`. Repo-wide: root `docs/`, `adr/`, `plans/`.
- Read the local docs before working, then root docs.
- One-service ADR/plan goes local; cross-service goes to root.
- Update local docs in the same PR as the code.

## §A Scaffolding a service
Confirm context with the Lead Architect (root ADR if new). Create §2 layout + §3 docs. Domain first (TDD), ports in core, thin adapters, wire in composition root. Add arch-lint config and repo linter. Targets: fmt, lint, lint-arch, vet, test, test-integration. Tests: unit, integration (emulators), contract. Run §1 gates.
- **Go:** `go mod tidy`; `.go-arch-lint.yml`; depguard bans SDKs in domain; integration behind build tags.
- **TS:** `strict: true`; UI never imports adapters; ESLint + boundaries.

## §B–§I Other standards
- **Integrations:** outbound adapter + ACL; idempotent consumers, backoff, DLQ; secrets from the store; live e2e behind flags.
- **Shared libs:** pure API, own arch-lint, no service deps, semver, ADR for breaking changes.
- **CLI/edge:** thin main; validate config at the edge; buffer offline; version payloads.
- **Infra/release:** IaC with synth + cdk-nag + template tests. Versions/CHANGELOG only via release-config-mgr. Prod deploy is an always-gate.
- **Specs:** OpenAPI / AsyncAPI / JSON Schema, linted, codegen, RFC 9457 errors.
- **Tests:** pyramid; red test first; never weaken assertions.

## PR flow
Use the repo's flow if it defines one. Default (sequential):
1. **Minions do all the work.** Push the branch and open a **draft** PR at the first commit (short task-name title, no W-id prefix, e.g. `build: machine-setup check-mode gap`; body links the task and STATUS.md) so Mario can follow. Implement, test, run gates (linter + arch-lint) green. Then internal minion reviews: Code Reviewer, Hexagonal Reviewer, Clean Arch Reviewer, plus Security Auditor / Test Reviewer when relevant. The owner fixes every finding; repeat until reviews are clean. The PR stays **DRAFT** and Copilot is **not** requested in this phase.
2. **Then Copilot loop (Dev Lead).** `gh pr ready`, request Copilot review, wait 10 min, owner fixes all comments and pushes, re-request. Repeat until no comments.
3. **Then merge.** All GitHub checks green, then Mario merges. Minions never merge.

Floci-only items: all evidence from local Floci; same three steps.

## GitHub issues and PRs
Org `Thiink-LLC`. `gh` needs the `project` scope (`gh auth status | grep project`); if missing, report BLOCKED. Never skip a failed step. Pick values yourself: Size Hours (<1 day), Days, or Split; Priority default Medium.

Priority and Size are **org issue fields**, not Project fields (`gh project item-edit` won't set them).

1. Issue: every issue must set a **Type**. Type is the repo's issue type, not a Project field (the R&D Sprint Board has no Type field). List the existing types live and pick one; never invent a value:
   `gh api graphql -f query='query{repository(owner:"Thiink-LLC",name:"<repo>"){issueTypes(first:50){nodes{name}}}}' -q '.data.repository.issueTypes.nodes[].name'`
   For teos on 2026-10-23 they were Task, Bug, Feature, Spike, Study, Long-Lived, Support. The live query wins if they differ.
   Then `gh label list -R Thiink-LLC/<repo>` (existing labels only), then `gh issue create -R Thiink-LLC/<repo> -t "<short task-name title, no W-id>" -b "<body>" -a mariotoffia -l "<labels>" --type "<Type>"`. Check it took: `gh issue view <N> -R Thiink-LLC/<repo> --json issueType -q .issueType.name`. Node id: `gh issue view <N> -R Thiink-LLC/<repo> --json id -q .id`.
2. Priority + Size:
```
gh api graphql -f query='mutation($i:ID!,$p:ID!,$s:ID!){setIssueFieldValue(input:{issueId:$i,issueFields:[{fieldId:"IFSS_kgDOAVq1qQ",singleSelectOptionId:$p},{fieldId:"IFSS_kgDOAsLCxw",singleSelectOptionId:$s}]}){clientMutationId}}' -f i=<ISSUE_NODE_ID> -f p=<PRIO_OPT> -f s=<SIZE_OPT>
```
   - Priority `IFSS_kgDOAVq1qQ`: Urgent `IFSSO_kgDOAl6mDA`, High `IFSSO_kgDOAl6mDQ`, Medium `IFSSO_kgDOAl6mDg`, Low `IFSSO_kgDOAl6mDw`
   - Size `IFSS_kgDOAsLCxw`: Hours `IFSSO_kgDOBNUasQ`, Days `IFSSO_kgDOBNUasg`, Split `IFSSO_kgDOBNUasw`
   - Leave Roadmap and Effort unset. Never create fields/options. Refresh ids: `gh api graphql -f query='{organization(login:"Thiink-LLC"){issueFields(first:20){nodes{... on IssueFieldSingleSelect{id name options{id name}}}}}}'`
3. R&D Sprint Board (project 2, `PVT_kwDOBoJzxs4BKY5X`): `ITEM=$(gh project item-add 2 --owner Thiink-LLC --url <issue-url> --format json -q .id)`
4. Status Incoming: `gh project item-edit --project-id PVT_kwDOBoJzxs4BKY5X --id $ITEM --field-id PVTSSF_lADOBoJzxs4BKY5Xzg6RWQI --single-select-option-id 1f493ca5`
5. Sprint = latest open iteration (never hardcode; never `completedIterations`; empty list = BLOCKED):
```
SPRINT=$(gh api graphql -f query='{node(id:"PVT_kwDOBoJzxs4BKY5X"){... on ProjectV2{field(name:"Sprint"){... on ProjectV2IterationField{configuration{iterations{id title startDate}}}}}}}' --jq '.data.node.field.configuration.iterations|sort_by(.startDate)|last|.id')
gh project item-edit --project-id PVT_kwDOBoJzxs4BKY5X --id $ITEM --field-id PVTIF_lADOBoJzxs4BKY5Xzg7d7CM --iteration-id $SPRINT
```
6. Verify, paste into STATUS.md:
   - `gh issue view <N> -R Thiink-LLC/<repo> --json projectItems` (board, Incoming)
   - `gh project item-list 2 --owner Thiink-LLC --format json --limit 1000 --jq '.items[]|select(.content.number==<N>)|.sprint'`
   - `gh api graphql -f query='{repository(owner:"Thiink-LLC",name:"<repo>"){issue(number:<N>){issueFieldValues(first:10){nodes{... on IssueFieldSingleSelectValue{name field{... on IssueFieldSingleSelect{name}}}}}}}}'` (Priority, Size)

**PR settings:** assignee `mariotoffia` (`gh pr create ... -a mariotoffia` or `gh pr edit <N> --add-assignee mariotoffia`). One `Closes #N` line per implemented issue (other repo: `Closes Thiink-LLC/<repo>#N`); never `Refs`/`Related`. Verify `gh pr view <N> --json assignees,closingIssuesReferences`. Non-default base: the PR owner runs `gh issue close <N> --reason completed` right after merge.

## Clean caches
After a task finishes (done, PR pushed), its coordinator (Dev Lead code, QA Lead tests, Platform Lead infra) runs or delegates `make clean-caches` in `/workspace/repos/teos`, only when minions are in sync:
- Run `make clean-caches`. It refuses and lists active runs (go build/test, golangci-lint, Floci, CDK) and exits non-zero without deleting anything. Then wait and retry; never kill another minion's run. `FORCE=1` only on Mario's explicit say-so.
- It also refuses (exit 2, nothing deleted) when it cannot read the process list or Docker; report that to your coordinator rather than force it.
- "directory not empty" from `go clean -cache`: a build started; wait and rerun.
- Log in STATUS.md with `df -h /` and `df -i /`. Over 85% disk or inodes: tell the CTO at once.

## Status and board
- `work/<id>/status.json`: `{id, title, phase, owner, autonomy, last_update (ISO-8601 with offset), next_step, blockers[], history[]}`.
- `STATUS.md` header: title, `Phase · Owner · Last update (Europe/Stockholm)`, Next step, Blockers, then `## Log`.
- Every minion appends on start, milestone, block, finish: `- <YYYY-MM-DD HH:MM> <slug> <start|milestone|blocked|done>: <≤1 sentence>`. Append only.
- **BOARD.md** (owner coordinator, every status change): "Legend", "How to update this board", one table `Task | Sub task | Description | Status | Last updated`, then "Blocked on Mario".
  - Parent row (blank Sub task, Description starts with W-id) plus one row per sub task.
  - Status icons only: ✅ done, 🔄 progress, 📐 designed, 👀 PR created and waiting for human review (reviews + Copilot clean, checks green), ⏳ waiting. New items ⏳. Done rows: purge rule in BOARD.md "How to update this board".
  - Short unique dotted lowercase names (`makefile.linux`, `floci.groundzero`); remote ids kept (`27.16.3`).
  - Last updated: real Stockholm `YYYY-MM-DD HH:MM` (convert UTC; else file mtime; never invent).
  - The CTO watchdog posts the board to buzz `teos-grok`.
- CTO messages Mario on every phase change and block: `<id> · <old>→<new> · owner · next · blockers`. Any coordinator answers "status?" directly.
