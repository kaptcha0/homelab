#!/usr/bin/env bash

set -euo pipefail
set -x

mkdir -p var/lib/secrets

cp ~/.config/sops/age/keys.txt var/lib/secrets/keys.txt

