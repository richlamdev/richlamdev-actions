# gitleaks-scanning

## Description
Scans the repository for secrets using [Gitleaks](https://github.com/gitleaks/gitleaks).
Supports scanning the latest commit or the full repository history, and can use a custom `.gitleaks.toml` config file.

---

## Inputs

| INPUT          | TYPE   | REQUIRED | DEFAULT           | DESCRIPTION |
|----------------|--------|----------|-------------------|-------------|
| config-path    | string | false    | `.gitleaks.toml`  | Path to the Gitleaks config file. If not found, Gitleaks defaults are used. |
| gitleaks-flags | string | false    | `""`              | Additional flags to pass to the Gitleaks CLI. |
| scan-mode      | string | false    | `latest-commit`   | Scan mode: `latest-commit` (only the pushed commit) or `full` (entire repo). |

---

## Outputs

_None_ (action only reports findings through logs and exit code)

---

## Usage

### Basic Example
```yaml
name: Security Scan

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  secret-scan:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Scan for secrets
        uses: ./.github/actions/gitleaks-scanning
        with:
          scan-mode: ${{ github.event.inputs.scan-mode || 'latest-commit' }}
          config-path: ${{ github.event.inputs.config-path || '.gitleaks.toml' }}
          gitleaks-flags: ${{ github.event.inputs.gitleaks-flags || '' }}

        # env:
        #   GITLEAKS_LICENSE_KEY: ${{ secrets.GITLEAKS_LICENSE }}
```
