# AWS access for minions

- Only account: `devlocal` (033549287452). Only region: `eu-west-1`, for everything (deploys, CDK, SAM, CLI, SDKs, tests).
- Always set both: `export AWS_PROFILE=devlocal AWS_REGION=eu-west-1 AWS_DEFAULT_REGION=eu-west-1`
- Verify before work: `aws sts get-caller-identity` (expect account 033549287452).
- CDK: `cdk bootstrap aws://033549287452/eu-west-1` once; `cdk deploy --profile devlocal`. Pin env `{account:'033549287452', region:'eu-west-1'}` in code.
- SSO is configured in `~/.aws/config` (sso-session `crossbreed`, profile `devlocal`). Credentials are short-lived.
- On expiry (ExpiredToken / "SSO session ... expired"): do NOT try other auth. Ask Solo to run `aws sso login --sso-session crossbreed --use-device-code`; Mario approves the code; then retry.
- Forbidden: other accounts/regions/profiles, IAM users or access keys, printing or copying credentials, deploys before the start gate (Mario's go).
