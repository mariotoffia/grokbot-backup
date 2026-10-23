# TEOS conventions and scaffolding checklists (for minions)

Source: the TEOS repo at `/workspace/thiink/teos`, as inspected on 2026-10-21. Minions working **inside the TEOS repo** treat `AGENTS.md` and the per-service governance docs as **authoritative**. This file is a checklist that points to them. If this file and the repo disagree, the repo wins, and you report the drift to the `technical-writer` minion through your coordinator.

Root docs this file depends on (read the relevant ones before you scaffold anything):
`AGENTS.md`, `ARCHITECTURE.md`, `DDD.md`, `UBIQUITOUS.md`, `CONVENTIONS.md`, `LINT.md`, `TESTS.md`, `BUILD_TAGS.md`, `DEVELOPMENT.md`, `API.md`, `API_SECURITY.md`, `API_ENDPOINT.md`, `DEPLOYMENT.md`, `DNS.md`, `SERVICE_TEST.md`, `SERVICE_TEST_WRITING.md`, `WEB_DEVELOPMENT.md`, `DOCUMENTATION.md`, `GITHUB.md`, `CUSTOMER_PRODUCT.md`, `go-core/PACKAGES.md`, `go-core/docs/adr/0001…0005`.

---

## §0 Repo-wide rules (from AGENTS.md)

| Rule | Source |
|---|---|
| Bootstrap every new worktree with `make dep` and then `make generate` before anything else. On a never-built host, run `make install` first. | AGENTS.md "MUST: bootstrap a new worktree" and "Build Commands" |
| Put worktrees in `<repo>/work/git-worktree/`. Delete them after merge. | AGENTS.md "Git Worktrees" |
| `./...` does not work from the repo root, because the root is a `go.work` workspace and not a module. Build and test per module through `make` targets. `go.work` is **not present in this snapshot** (see open question Q1). | AGENTS.md |
| Load `go-core/PACKAGES.md` before you generate code. Reuse go-core instead of re-inventing SQS, S3 or event helpers. | AGENTS.md, Testing specific |
| Use `ifcore.CbContext`, never a bare `context.Context`, in user code. | AGENTS.md "context.Context", CONVENTIONS.md §Context |
| Log through `go-core/logger/log`. Use the `…WithLocationID` variants when a location ID exists. Wrap debug and trace logs in `log.IsEnabled(...)`. | AGENTS.md "Logging", CONVENTIONS.md §Logging |
| Handlers must use `go-core/tkdisp/{cbhttp,cblambda,cbsqs}` and be prepared for `cbpolicy` checks. | AGENTS.md "Handlers", CONVENTIONS.md §Dispatch/§Policy |
| REST APIs use `cbhttp` and return `ProblemDetails` errors from a `cberror.Error`. Read API.md §9 before adding an API. | AGENTS.md "API" |
| Stored data: adjacent releases must read each other's rows. Changes only **add** attributes. Migration jobs, dual readers, field aliases and "rewrite on read" are forbidden. | AGENTS.md "Stored data", ADR-0004 |
| Keep Go files and doc files to about 600 lines. Split them; do not cut documentation. | AGENTS.md "Development Standards" |
| Unit and integration tests go in the `<package>_test` package. Reuse `go-core/utils/testutils`, `awstestutil` and `go-core/managers/**`. | AGENTS.md "Testing specific" |
| Comments describe what the code IS. No plan IDs, task IDs, commit hashes or "used to" stories. | AGENTS.md "MUST: Never document any plan ID…" |
| All prose (docs, PRs, commits) must be plain, simple English for an engineer who has never opened the repo. The banned-metaphor list applies. | AGENTS.md "MUST: Only use plain, simple, English" |
| `.go-arch-lint.yml` changes need a thorough evaluation **and an ADR**. | AGENTS.md "Architecture & Design Principles" |
| Respect `.cbrepo-locks.json` module locks, even for Dependabot. | AGENTS.md "References" |
| Talk to GitHub as GITHUB.md says. CI jobs are label-gated (`TESTS.md` "CI / Pull Request Labels", `cbtest pr`). | AGENTS.md "Github" |
| New uServices and new `_design/**` folders get a `Makefile` with the targets they need. | AGENTS.md "Makefile" |
| Run `make tidy` after changing imports. Never hand-edit `go.mod`. | AGENTS.md "Build Commands" |

## §1 Quality gates (every code change)

Run these from the repo root unless the row says otherwise.

| Gate | Command | What it covers |
|---|---|---|
| Format | `make fmt` (`fmt-go`, `fmt-rego`, `fmt-ts`) | gofmt, Rego formatting, Prettier (`.prettierrc.json`: width 120, double quotes, trailing comma es5) |
| Lint (full chain) | `make lint` = `lint-examples` → `lint-go` → `lint-arch` → `make -C web lint` | LINT.md §Run order |
| Go lint | `make lint-go` (or a module's own `make lint`, which runs golangci-lint **from the repo root**) | `.golangci.yml`, including depguard, forbidigo and the build-tag passes from `LINT_TAGS` (BUILD_TAGS.md) |
| Architecture | `make lint-arch` (finds every Makefile with a `lint-arch` target) | per-module `.go-arch-lint.yml`, LINT.md §go-arch-lint |
| Rego | `make vet-rego` (regal, `.regal/config.yaml`) | policies under `handlers/*/policies`, `go-core/cbpolicy` |
| Vet | `make vet` | every go.work module, with the lint tags |
| Unit tests | `make test` | needs no Docker and no AWS |
| Integration | `make test-integration` (local emulator, Docker) or `make test-integration-cloud` (AWS account, credentials) | TESTS.md |
| Service tests | `make test-service` / `make test-service-cloud` | `deployment/service-test`, SERVICE_TEST*.md |
| Web | `make web-test`, plus `pnpm -r lint` / `pnpm -r typecheck` / `pnpm -r test` | eslint `--max-warnings=0`, `tsc --noEmit`, vitest |
| CI fresh-clone guard | `make dep && git diff --exit-code` (in `.github/workflows/build.yml`) | catches CLIs placed in the wrong Make phase |
| Local CI | `make act-lint`, `make act-test` | the CI jobs, run through act |

CI workflows: `.github/workflows/{build,lint,archlint,cascade-merge,gobridge-integration}.yml`.

## §2 Governance-doc set per module

Today, only these modules carry the full DDD document set: `go-services/appstore`, `go-services/realestatecore`, `go-services/core/brokers/gobridge`, `go-services/providers/eastbound/realestatecore`, `go-core/cbpipeline` and `go-core/cbanalytics`. Most services only have a `Makefile`, `_design/` and `manifest/`. New modules follow the **gobridge** set.

| File | Required for a new… | Notes |
|---|---|---|
| `Makefile` | every module | targets listed in each section below |
| `.go-arch-lint.yml` | uService, provider, go-core library with layers | 10 maps exist today (LINT.md) |
| `ARCHITECTURE.md` | uService, provider, library | layer diagram plus design goals |
| `DDD.md` | uService, library with a domain | bounded context, aggregates, events, invariants |
| `UBIQUITOUS.md` | uService, library with a domain | append-only glossary. Service-local terms win over root terms. |
| `PERSONAS.md` | uService with users | gobridge, realestatecore, cbanalytics, cbpipeline |
| `README.md` | library, CLI, client module | |
| `_design/Makefile` (+ `*.adoc`) | every uService and provider | `include …/docs_meta.mk`. Build with `make docs` through asciidoctor. Audience attributes: `target-architect`, `target-developer`, `target-operations`, `target-provider`. |
| `docs/adr/NNNN-*.md` | when a decision passes the ADR test | examples: `go-core/docs/adr`, `gobridge/docs/adr`, `eventsvc/evidencemonitor/docs/adr` |
| `manifest/manifest.json`, `provision-schema.json`, `features/root.md` | every deployable uService, provider or web app | used by cbdeploy and the AppStore |
| `TESTING.md` | optional. gobridge has one. | the root `TESTS.md` is the general guide |
| `CONVENTIONS.md` | optional (appstore has one) | service-specific rules |

---

## §A New Go microservice (uService)

**Template:** `go-services/core/management/alarm-service` for code layout. Use `go-services/core/brokers/gobridge` for the governance-doc set, the Makefile shape (`build test test-integration test-service lint lint-arch vet fmt clean`) and `deployment/service-test`.

### A.1 Directory skeleton

```text
go-services/<area>/<svc>/                 # e.g. go-services/core/management/<svc>
├── go.mod                                # own module: github.com/Thiink-LLC/teos/go-services/<area>/<svc>
├── Makefile                              # build, test, test-integration, test-service, lint (+lint-arch), vet, fmt, clean, clean-generated, generate-api, generate-code, bundle, docs
├── .go-arch-lint.yml                     # copy alarm-service's map; components api/core/adapters/handlers (+migrations only if ADR-approved)
├── ARCHITECTURE.md  DDD.md  UBIQUITOUS.md  PERSONAS.md
├── _design/Makefile  _design/overview.adoc
├── api/
│   ├── http-api.yaml                     # OpenAPI; /v1/... path keys; OAuth2 scheme; per-operation scopes (API.md §9)
│   ├── redocly.yaml
│   └── client/{types.cfg.yaml,go.mod?}   # oapi-codegen config (a nested module needs an arch-lint *component*, not an exclude)
├── handlers/<handlerName>/
│   ├── main.go                           # sets up tkdisp (cbhttp / cblambda / cbsqs)
│   ├── service/*.go                      # handler-private service code
│   ├── policies/*.rego                   # access policy
│   ├── pdp-config/*.json                 # PROCESS <name>/access registration
│   ├── provider-config/  service-config/ # when needed
│   └── lambda/ api/                      # ONLY when one handler has both a Lambda and an API binding
├── internal/
│   ├── core/domain/<aggregate>/          # pure domain, no AWS SDK
│   ├── core/ports/{inbound,outbound}/
│   ├── core/application/
│   └── adapters/{inbound/rest,outbound/<repository|eventpublisher|notifier|dynamodb…>}/
├── manifest/{manifest.json,provision-schema.json,features/root.md}
├── deployment/
│   ├── go.mod  cdk.json  main.go  stack*.go  Makefile   # GOWORK=off; build synth deploy destroy verify
│   └── service-test/{go.mod,provision-config.yaml,_design/Makefile}
└── docs/adr/                             # optional
```

### A.2 Checklist

1. Read `ARCHITECTURE.md`, `DDD.md` and `UBIQUITOUS.md` (root), then `CONVENTIONS.md`, `API.md`, `go-core/PACKAGES.md` and `go-core/tkdisp/_design/*`.
2. Write the bounded-context entry in the root `DDD.md`, and service-local `DDD.md`/`UBIQUITOUS.md`. New terms need grant approval through the Lead Architect minion.
3. Create the module (`go.mod`), add it to the `go.work` module list (see Q1), then run `make tidy`.
4. Copy `.go-arch-lint.yml` from alarm-service. Map from **direct** imports (`go list -f '{{.Imports}}'`), never `-deps`. Add a `lint-arch` target and make `lint` depend on it. The root `lint-arch` finds it automatically.
5. Write handlers per AGENTS.md "Handlers". Use `cbhttp.NewAccessMux` + `WithBasePath` + `CognitoContextFactory`, and return `cberror.Error`.
6. Write the API per API.md §9 (13 steps): OpenAPI, scopes, `iam.scopeSources` in `deployment/provision-config.yaml`, `idm.RegisterIAMContribution`, Rego policy, grants.
7. Write the manifest. Copy gobridge's: `name`, `configName`, `version`, `type`, `category`, `stackName` `teos-<x>`, `cdkPath: deployment`, `dependencies` (at least `groundzero` / `iam-service`), `services[]` or `providers[]`, `features[]`.
8. Write the CDK stack in `deployment/` (Go CDK, `GOWORK=off`). Add a synth test with `assertions.Template_FromStack`.
9. Tests: unit tests (`_test` package), integration tests (`integration` tag, Floci/Docker), a service test in `deployment/service-test` (SERVICE_TEST_WRITING.md), and `cbhttp` `Invoke` handler tests.
10. Write `_design/overview.adoc` and its Makefile `docs` target.
11. Run the gates in §1. The minimum is `make fmt lint vet test`, plus `make -C <svc> test-integration` when integration tests exist.
12. If the service is wired into the root `build`: `go-services/Makefile` forwards only one level down, so nested services need their parent Makefile to forward (gobridge's Makefile header explains how).

## §B New provider (eastbound / northbound / westbound)

**Template:** `go-services/providers/eastbound/sur`. It is its own module, has an arch-lint map, an `internal/core` layout, an `api/client` nested module, `model/`, and handler `pdp-config` + `provider-config/{generic.json,teos/,test/}`. Southbound is **reserved**: there is no directory for it, only an enum and schema slot.

```text
go-services/providers/<east|north|west>bound/<name>/
├── go.mod  Makefile  .go-arch-lint.yml     # components: api-client, model, core, adapters, handlers
├── model/<name>model/                      # provider wire vocabulary (reaches nothing in-module)
├── internal/core/{domain,ports/{inbound,outbound},application}/
├── internal/adapters/{inbound,outbound}/…  # ACL: vendor DTO → TEOS model, here only
├── handlers/<pt>/{main.go,handler.go,pdp-config/*.json,provider-config/{generic.json,teos/generic.json,test/generic.json}}
├── api/{http-api.yaml,client/{go.mod,types.cfg.yaml}}   # only if the provider exposes REST
├── manifest/{manifest.json,provision-schema.json,features/{root.md,root.svg,root.icon.svg}}
├── deployment/{go.mod,cdk.json,main.go,stack*.go,Makefile,service-test/}
└── _design/{Makefile,overview.adoc}
```

Checklist:

1. Pick the direction. `east` covers equipment/BMS/IoT, `north` covers APIs that TEOS publishes, `west` covers optimisation.
2. In `manifest.json`, `type: provider`, `category: provider`. Add one `providers[]` row per handler: `pn` (name), `pd` (east|north|west), `pt` (provider type, e.g. `esv`, `cfo`, `async-sv`, `configchange`), `st` (`provider` | `core-service`), `fd` (`egress` | `ingestion`), `flow` (e.g. `west-east`, `core-east`, `east-core`). Dependencies: `building-service`, `iam-service`.
3. Use `go-core/{provider,providersdk,cbtransport}`. Keep credentials in SSM through `go-core/aws/providersdk/auth/ssmstore`. Never commit credentials.
4. Arch map (sur): `core → [core, model]`, `adapters → [core]`, `handlers → [handlers, core, adapters, model, api-client]`.
5. If the provider has REST, follow §A step 6 (API.md §9). If a nested module shares the import prefix, add it to `cmd/go.mod` `replace` only when a CLI imports it (sur's client is an example).
6. Use `cmd/cbprov` operations (`provider`, `pack`, `collector`, `config-dispatch`, `device`) to exercise the provider locally.
7. Put vendor e2e tests behind the `e2e` tag (`sma/e2e-tests` is an example). Integration tests use the `integration` tag.
8. Run the §1 gates, plus `make -C go-services/providers/<dir>/<name> lint` (which runs lint-arch).
9. Docs: `_design/overview.adoc` (sur's `docs` target uses the `target-provider` audience). Update the provider list in the root `README.md`/`AGENTS.md` project structure through a `technical-writer` packet.

## §C New go-core library

**Template:** `go-core/cbanalytics` (full doc set plus its own arch map). `go-core/cberror` is the minimal flat-package example. go-core is **one module** (`go-core/go.mod`). `go-core/cbpolicy/prp/dynamodbprp` shows a nested module, which is rare.

```text
go-core/<lib>/
├── <lib>.go  *_test.go (package <lib>_test for exported API)
├── README.md
├── ARCHITECTURE.md  DDD.md  UBIQUITOUS.md      # when the library has a domain (cbanalytics, cbpipeline)
├── .go-arch-lint.yml + Makefile lint-arch      # when it has internal layers
├── _design/{Makefile,*.adoc}                   # optional
└── docs/adr/                                   # or go-core/docs/adr for cross-library decisions
```

Checklist:

1. Check `go-core/PACKAGES.md` first, so you do not duplicate an existing package. Put ports in `go-core/interfaces/*` when other modules implement them.
2. Add the package to the `go-core/PACKAGES.md` tree with a one-line description (required: AGENTS.md tells agents to load this file).
3. If the library has layers, use the in-module arch-map recipe `go-arch-lint check --project-path .. --arch-file <lib>/.go-arch-lint.yml` with `workdir:` (LINT.md §go-arch-lint table).
4. Keep the library AWS-free unless it lives under `go-core/aws/**` or is an adapter package.
5. Go examples must not put an output comment directly after a `// end::` tag (`make lint-examples`).
6. Run the gates. A new module-wide build tag must follow BUILD_TAGS.md §Adding a build tag.

## §D New web package or app (pnpm / React / TS)

**Template:** `web/teos` (`@thiink/teos-web`) for an app. Use `web/design/tokens` (`@thiink/design-tokens`) for a library package. `pnpm-workspace.yaml` lists `web/design/tokens`, `web/design/ui` (`@thiink/ui`, which AGENTS.md does not mention yet), `web/teos` and `cmd/tklocal/webui`.

```text
web/<app>/
├── package.json        # "name": "@thiink/<app>", private, "type": "module"
│                       # scripts: dev, build ("tsc --noEmit && vite build"), lint ("eslint src/ --max-warnings=0"),
│                       #          typecheck ("tsc --noEmit"), test ("vitest run"), generate:api (openapi-typescript …)
├── tsconfig.json       # ES2022, moduleResolution bundler, strict, noUnusedLocals/Parameters, noUncheckedIndexedAccess, paths @/* → src/*
├── eslint.config.js    # @eslint/js + typescript-eslint + react-hooks + react-refresh (copy web/teos)
├── vite.config.ts  vitest.config.ts  vite-env.d.ts
├── Makefile            # generate-code, build, serve-dev (+ verify targets as needed)
├── manifest/{manifest.json,provision-schema.json}   # when deployed as a TEOS app
├── deployment/{go.mod,main.go,stack.go}             # Go CDK stack for hosting
└── src/{main.tsx,App.tsx,api/,auth/,components/,features/,hooks/,lib/,stores/,test/,__tests__/}
```

Checklist:

1. Add the path to `pnpm-workspace.yaml`. Add root `package.json` scripts (`build:<app>`, `dev:<app>`) when developers need them.
2. Depend on `"@thiink/design-tokens": "workspace:*"` and `"@thiink/ui": "workspace:*"`. Never hard-code brand colours (the token table is in AGENTS.md).
3. State: Zustand for client state, TanStack Query for server state. API calls use openapi-fetch with types from `openapi-typescript`, generated from the service bundles in `go-services/**/_dist/_output/api/http-api.yaml`. Validate with zod. Mock APIs with MSW in tests.
4. Wire the app into `web/Makefile` (`build`, `lint`, `typecheck`, `generate-api`, `generate-code`, `clean-generated`) so the root `make build`/`make lint`/`make generate` reach it.
5. Gates: `pnpm -F @thiink/<app> lint typecheck test`, `pnpm format:check`, `make -C web lint`, `make web-test`.
6. Update WEB_DEVELOPMENT.md and the AGENTS.md "Web & Frontend" table through a technical-writer packet when the stack changes.

## §E New CLI under `cmd/`

**Template:** `cmd/cbprov` (a workspace CLI in the `cmd` module, `github.com/Thiink-LLC/teos/cmd`, which uses `replace` to point at go-core/go-services/deployment-lib). Use `cmd/cbrepo` or `cmd/cbgenerate` for a **standalone** CLI with its own `go.mod`, built with `GOWORK=off`.

Placement decision tree (DEVELOPMENT.md "Adding a new CLI command"):

1. Codegen needs it on PATH during `make generate` → `cmd/Makefile` `install:`. Only `cbgenerate` qualifies today.
2. It imports generated code (an `api/client`) → put it under the owning service, `go-services/<svc>/cmd/<tool>`. Install it from that service's Makefile `build:`. `appstore/cmd/cbdeploy` is the precedent.
3. Otherwise → `cmd/<tool>/`, and add `go install ./<tool>` to `cmd/Makefile` `build:`.

```text
cmd/<tool>/
├── main.go        # load .env via envutils.LoadDotEnv(); usage text; dispatch actions (cbprov runner pattern)
├── op_<action>.go  op_<action>_test.go
└── README.md      # recommended
```

Checklist: wire `cmd/Makefile` `build:` → `make -C cmd build` → `make lint vet test`. The CI guard `make dep && git diff --exit-code` must stay green. Document the tool in DEVELOPMENT.md or the owning service docs.

---

## §F Deployment, manifests, module locks

- cbdeploy (`go-services/appstore/cmd/cbdeploy`) is manifest-driven. Every deployable unit has `manifest/manifest.json` (32 exist today). DEPLOYMENT.md describes Mode A (local/developer-driven, the supported path) and Mode B (AppStore, in progress). Do not mix modes per service.
- Provision configs: `deployment/provision-config.yaml` (root), service-test configs, and customer folders `customers/<customer>/provision-config.yaml` (CUSTOMER_PRODUCT.md). Applying a customer provision is an always-gate.
- CDK is Go: `deployment/lib/{core,adapters,infrastructure,svctest,tests}` and `deployment/stacks/groundzero`. Per-service `deployment/` modules use `GOWORK=off` and the targets `build synth deploy destroy verify` (cdk-nag).
- `.cbrepo-locks.json` holds module pins, each with `module`, `version`, `reason` and `until`. Today the only pin is `github.com/dprotaso/go-yit`. Use `make go-resync` / `cmd/cbrepo` for version sync. Only the release-config-mgr minion edits locks.
- Releases: `make release` / `make release-dry-run`, plus `CHANGELOG.md`. Cascade merges run in `.github/workflows/cascade-merge.yml`.

## §G API specs (`meta/spec`)

- APIs that several services or outside partners share live under `meta/spec/api/<name>/` (today: mac, open-adr-3, rtc, sca, sda, siemens, sma, srp, ssa, ssm). Shared models live under `meta/spec/model/*`. They are bundled with Redocly (`meta/spec/redocly.yaml`) into `meta/spec/_output`.
- Service-owned APIs live in `<svc>/api/http-api.yaml` and are bundled into `_dist/_output/api/`. Generated Go models go to `go-services/model/*` (rtcapi, scapi, …).

## §H Docs layout

- `documentation/` is the Antora/AsciiDoc site (DOCUMENTATION.md, built with `cbdoc antora scan|stage`). Component `_design/` folders in each module use `docs_meta.mk`.
- Root `*.md` files are governance documents. `docs/` holds `KNOWN_DEFECTS_*`.
- Doc files stay at about 600 lines. Append-only working documents (plans, reviews) are exempt.

## §I Test layout

- Unit tests sit next to the code (`_test` package). Integration tests use the `integration` tag (Docker/Floci, or cloud with `test-integration-cloud`). e2e tests use the `e2e` tag. Floci-specific code uses the `floci` tag (BUILD_TAGS.md).
- Service tests: `<svc>/deployment/service-test/` (its own module), `deployment/lib/svctest`.
- Shared helpers: `go-core/utils/testutils/**`. `go-services/testutils` is being deprecated. `go-services/httpmock`. `cmd/cbtest` (it also toggles PR labels: `cbtest pr`). Repo-level tests live in `tests/unit`.
- A `.do-not-test` file in a module skips it in `make test`. Its first line must give the reason.

---

## Open questions found while inspecting

- **Q1:** `go.work` is referenced by the Makefile, AGENTS.md and DEVELOPMENT.md, but it is missing from this snapshot. It may be uncommitted or generated, or the extract may have dropped it. Confirm how a new module gets registered in it.
- **Q2:** `go-services/core/management/alarm-service` has a `migrations/` arch-lint component. AGENTS.md "Stored data" forbids one-shot migration jobs. New services should not copy that component without an ADR.
- **Q3:** AGENTS.md lists pnpm workspaces without `web/design/ui` (`@thiink/ui`), but `pnpm-workspace.yaml` includes it.
- **Q4:** AGENTS.md says to "use skill-create-test" and "skill-asciidoc-documentation". These skills exist in the older thiink `_dist` output, but they are not in the Grok Bot skills inventory. Map them to `test-driven-development` and the technical-writer minion, or install them.
