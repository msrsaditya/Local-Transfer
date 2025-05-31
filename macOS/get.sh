#!/usr/bin/env bash
set -euo pipefail

folder="${1:-${HOME}}"
port=64943

mkdir -p "${folder}"

nc -l -w 60 "${port}" | {
  IFS= read -r file
  read -r expected_bytes

  if [[ -z "${file}" ]]; then
      tar --no-same-owner --warning=no-unknown-keyword -xpf - -C "${folder}"
      exit 0
  fi

  path="${folder}/${file}"
  cat > "${path}"

  actual_bytes=$(stat -f%z "${path}")

  if [[ "${expected_bytes}" -ne "${actual_bytes}" ]]; then
    echo "Error: Incomplete Transfer" >&2
    exit 1
  fi
}
