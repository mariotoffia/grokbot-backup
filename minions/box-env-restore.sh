#!/usr/bin/env bash
# Idempotent box env restore (docker, floci image, nvm/node/pnpm). No secrets, no /etc/hosts, no AWS.
set -euo pipefail
FLOCI_REF="mariotoffia/floci:latest"
NVM_VER="v0.40.8"; NODES=(22.23.4 24.19.0); DEFAULT_NODE=22.23.4; PNPM_VER=10.33.0
log(){ echo "[$(date -Iseconds)] $1: $2"; }
dk(){ if docker info >/dev/null 2>&1; then docker "$@"; else sg docker -c "docker $*"; fi; }

if command -v docker >/dev/null; then log docker-install skip; else curl -fsSL https://get.docker.com | sudo sh; log docker-install done; fi
if [ "$(stat -c %a /var/run)" = 755 ] || [ -L /var/run ]; then log chmod-var-run skip; else sudo chmod 755 /var/run; log chmod-var-run done; fi
if pgrep -x dockerd >/dev/null; then log dockerd skip; else sudo nohup dockerd >/tmp/dockerd.log 2>&1 & for i in $(seq 30); do sudo docker info >/dev/null 2>&1 && break; sleep 1; done; log dockerd done; fi
if id -nG "$USER" | tr ' ' '\n' | grep -qx docker; then log docker-group skip; else sudo usermod -aG docker "$USER"; log docker-group done; fi
dk pull -q "$FLOCI_REF" >/dev/null; log floci-pull "$(dk image inspect -f "{{join .RepoDigests \",\"}}" "$FLOCI_REF")"

unset NPM_CONFIG_PREFIX; export NVM_DIR="$HOME/.nvm" COREPACK_HOME="$HOME/.cache/node/corepack"
if [ -s "$NVM_DIR/nvm.sh" ]; then log nvm-install skip; else curl -fsSo- "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VER/install.sh" | PROFILE=/dev/null bash; log nvm-install done; fi
set +u; . "$NVM_DIR/nvm.sh" --no-use
for v in "${NODES[@]}"; do
  if [ -d "$NVM_DIR/versions/node/v$v" ]; then log "node-$v" skip; else nvm install "$v" >/dev/null; log "node-$v" done; fi
  nvm use "$v" >/dev/null
  if [ "$(pnpm -v 2>/dev/null || true)" = "$PNPM_VER" ]; then log "pnpm-$v" skip; else corepack enable; corepack prepare "pnpm@$PNPM_VER" --activate >/dev/null; log "pnpm-$v" done; fi
done
if [ "$(nvm version default)" = "v$DEFAULT_NODE" ]; then log nvm-default skip; else nvm alias default "$DEFAULT_NODE" >/dev/null; log nvm-default done; fi

# ---- build toolchain for teos Makefiles (W-2026-0004 tool matrix) ----
set -u
TEOS=/workspace/repos/teos
PANDOC_VERSION=3.11; OPA_VERSION=v1.10.1; ACT_VERSION=v0.2.82; GO_MIN=1.25
ARCH=$(dpkg --print-architecture)
APT_PKGS=(build-essential make jq unzip zip git-lfs zsh lsof wget upx-ucl nsis asciidoctor restic)
missing=(); for p in "${APT_PKGS[@]}"; do dpkg -s "$p" >/dev/null 2>&1 || missing+=("$p"); done
if [ ${#missing[@]} -eq 0 ]; then log apt-tools skip; else
  for i in 1 2 3; do sudo apt-get -o Acquire::Retries=5 update -qq && break; sleep 5; done
  sudo DEBIAN_FRONTEND=noninteractive apt-get -o Acquire::Retries=5 install -y -qq "${missing[@]}" >/dev/null; log apt-tools "done (${missing[*]})"; fi
if git lfs env 2>/dev/null | grep -q 'filter.lfs.process'; then log git-lfs-init skip; else git lfs install --skip-repo >/dev/null; log git-lfs-init done; fi
if command -v pandoc >/dev/null && pandoc --version | head -1 | grep -q " $PANDOC_VERSION\$"; then log pandoc skip; else
  d=/tmp/pandoc-$PANDOC_VERSION-1-$ARCH.deb; curl -fsSL --retry 5 -o "$d" "https://github.com/jgm/pandoc/releases/download/$PANDOC_VERSION/pandoc-$PANDOC_VERSION-1-$ARCH.deb"; sudo dpkg -i "$d" >/dev/null; rm -f "$d"; log pandoc done; fi
if command -v opa >/dev/null; then log opa skip; else
  curl -fsSL --retry 5 -o /tmp/opa "https://openpolicyagent.org/downloads/$OPA_VERSION/opa_linux_${ARCH}_static"; sudo install /tmp/opa /usr/local/bin/opa; rm -f /tmp/opa; log opa done; fi
mkdir -p "$HOME/.local/bin"
if [ -x "$HOME/.local/bin/act" ] || command -v act >/dev/null; then log act skip; else
  a=$([ "$ARCH" = amd64 ] && echo x86_64 || echo arm64)
  curl -fsSL --retry 5 "https://github.com/nektos/act/releases/download/$ACT_VERSION/act_Linux_$a.tar.gz" | tar -xz -C "$HOME/.local/bin" act; log act done; fi
gv=$(go env GOVERSION 2>/dev/null | sed 's/^go//' || true)
if [ -n "$gv" ] && [ "$(printf '%s\n' "$GO_MIN" "$gv" | sort -V | head -1)" = "$GO_MIN" ]; then log "go($gv>=$GO_MIN)" skip; else
  gt=$(curl -fsSL 'https://go.dev/VERSION?m=text' | head -1); curl -fsSL --retry 5 "https://go.dev/dl/$gt.linux-$ARCH.tar.gz" | sudo tar -C /usr/local -xz; sudo ln -sf /usr/local/go/bin/go /usr/local/bin/go; log go "done ($gt)"; fi
GOTOOLS=(go-arch-lint golangci-lint gotestsum golines gomajor goasciidoc scc go-licenses regal oapi-codegen cbgenerate)
miss=(); for t in "${GOTOOLS[@]}"; do [ -x "$HOME/go/bin/$t" ] || miss+=("$t"); done
if [ ${#miss[@]} -eq 0 ]; then log go-bin-tools skip; else
  REGAL=$(sed -n 's/^REGAL_VERSION := //p' $TEOS/Makefile); OAPI=$(sed -n 's/^OAPI_CODEGEN_VERSION ?= //p' $TEOS/Makefile)
  (cd $TEOS/tools && GOWORK=off go install tool) && (cd $TEOS/tools/go-licenses && GOWORK=off go install tool) \
  && go install "github.com/open-policy-agent/regal@$REGAL" && go install "github.com/oapi-codegen/oapi-codegen/v2/cmd/oapi-codegen@$OAPI" \
  && (cd $TEOS/cmd/cbgenerate && GOWORK=off go install .); log go-bin-tools "done (${miss[*]})"; fi
if [ -x "$HOME/.local/bin/cdk" ] && [ -x "$HOME/.local/bin/pnpm" ]; then log npm-global-cdk-pnpm skip; else
  set +u; nvm use "$DEFAULT_NODE" >/dev/null; npm install -g --prefix "$HOME/.local" aws-cdk "pnpm@$PNPM_VER" >/dev/null; set -u; log npm-global-cdk-pnpm done; fi
# Node default for non-interactive shells: ~/.local/bin shims -> nvm v$DEFAULT_NODE (~/.local/bin is on PATH via agent env and ~/.profile)
NB="$NVM_DIR/versions/node/v$DEFAULT_NODE/bin"; ok=1
for b in node npm npx corepack pnpm; do [ "$(readlink "$HOME/.local/bin/$b" 2>/dev/null)" = "$NB/$b" ] || ok=0; done
if [ $ok = 1 ]; then log node-shims skip; else
  for b in node npm npx corepack pnpm; do [ -e "$NB/$b" ] && ln -sfn "$NB/$b" "$HOME/.local/bin/$b"; done
  [ -e "$NB/pnpx" ] && ln -sfn "$NB/pnpx" "$HOME/.local/bin/pnpx"; log node-shims done; fi
