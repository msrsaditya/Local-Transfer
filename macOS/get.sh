#!/usr/bin/env bash
set -euo pipefail

folder="${1:-${HOME}}"
port=64943

mkdir -p "${folder}"

nc -l -w 60 "${port}" | {
  IFS= read -r file
  if [[ -z "${file}" ]]; then
    tar --no-same-owner -xpf - -C "${folder}"
  else
    cat > "${folder}/${file}"
  fi
}
