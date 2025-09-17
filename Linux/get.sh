#!/usr/bin/env bash
set -euo pipefail

folder="${1:-${HOME}}"
timeout=60
port=64943
blocks=8192

mkdir -p "${folder}"

nc -l -w "${timeout}" "${port}" | {
  IFS= read -r file
  if [[ -z "${file}" ]]; then
    tar --warning=no-unknown-keyword -b"${blocks}" -xpof- -C"${folder}"
  else
    cat > "${folder}/${file}"
  fi
}
