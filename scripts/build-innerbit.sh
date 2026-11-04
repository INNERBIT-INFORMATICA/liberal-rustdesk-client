#!/usr/bin/env bash
# Backwards-compatible shortcut for: ./scripts/build-client.sh innerbit ...
# Branding values live in branding/innerbit/preset.env.
set -euo pipefail
exec "$(dirname "${BASH_SOURCE[0]}")/build-client.sh" innerbit "$@"
