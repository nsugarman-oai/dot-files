#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
config_path="$repo_root/files/config/starship.toml"

output="$(NO_COLOR=1 STARSHIP_CONFIG="$config_path" starship module time)"
[[ "$output" =~ ^@\ ([1-9]|1[0-2]):[0-5][0-9](am|pm)\ $ ]]
