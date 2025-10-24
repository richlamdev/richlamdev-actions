#!/usr/bin/env bash
set -euo pipefail

# Validate config-path (only allow safe path characters)
if [[ -n "${CONFIG_PATH:-}" ]]; then
  if [[ ! "$CONFIG_PATH" =~ ^[a-zA-Z0-9._/-]+$ ]]; then
    echo "::error::Invalid config-path. Only alphanumeric, dots, underscores, hyphens, and slashes allowed"
    exit 1
  fi
  # Prevent directory traversal
  if [[ "$CONFIG_PATH" == *".."* ]]; then
    echo "::error::Invalid config-path. Directory traversal not allowed"
    exit 1
  fi
fi

# Validate scan-mode (only allow specific values)
if [[ "$SCAN_MODE" != "latest-commit" && "$SCAN_MODE" != "full" ]]; then
  echo "::error::Invalid scan-mode. Must be 'latest-commit' or 'full'"
  exit 1
fi

# Validate gitleaks-flags (if provided)
if [[ -n "${GITLEAKS_FLAGS:-}" ]]; then
  # Only allow safe flag patterns (flags starting with -- and safe characters)
  if [[ ! "$GITLEAKS_FLAGS" =~ ^(--[a-z-]+(=[a-zA-Z0-9._/,-]+)?(\s+|$))*$ ]]; then
    echo "::error::Invalid gitleaks-flags format. Only standard flag formats allowed"
    exit 1
  fi
  # Explicitly block dangerous flags
  if [[ "$GITLEAKS_FLAGS" == *";"* ]] || [[ "$GITLEAKS_FLAGS" == *"|"* ]] ||
    [[ "$GITLEAKS_FLAGS" == *"&"* ]] || [[ "$GITLEAKS_FLAGS" == *'$('* ]] ||
    [[ "$GITLEAKS_FLAGS" == *'`'* ]] || [[ "$GITLEAKS_FLAGS" == *">"* ]] ||
    [[ "$GITLEAKS_FLAGS" == *"<"* ]]; then
    echo "::error::Invalid gitleaks-flags. Shell operators not allowed"
    exit 1
  fi
fi

echo
echo "✓ Input validation passed"
