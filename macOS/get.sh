#!/usr/bin/env bash
set -euo pipefail

folder="${1:-${HOME}}"
port=64943
blocks=8192
timeout=60

mkdir -p "${folder}"

nc -l -w "${timeout}" "${port}" | {
  IFS= read -r file
  if [[ -z "${file}" ]]; then
    tar -b"${blocks}" -xpof- -C"${folder}"
  else
    cat > "${folder}/${file}"
  fi
}
