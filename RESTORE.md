# Restore Grokbot box state
1. `gh auth login` (device code), then `gh repo clone mariotoffia/grokbot-backup /tmp/grokbot-backup && bash /tmp/grokbot-backup/restore.sh`
2. restore.sh: copies minions -> /workspace/minions and /workspace/thiink/minions (identical), unpacks minions-work-inbox.tgz (work/, inbox/), thiink reports, buzz/state.json, skills -> /home/box/agent-data/workflows; clones Thiink-LLC/teos and mariotoffia/floci into /workspace/repos; runs teos machine-setup.sh (main, else PR #1248 branch).
3. Re-authenticate via device codes (gh, AWS SSO, connectors). No credentials are stored here.
4. Backups: `bash backup.sh` (commits+pushes only if changed). Not included: thiink/teos (clone), thiink/meta, thiink/plugin, ~/.aws, ~/.config, chrome profile, .env.
