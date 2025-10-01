#!/usr/bin/env bash
set -euo pipefail

path="${1}"
ip="${2}"
port=64943
blocks=8192
flags=(-f -b -t -r -a -p -e -k -i 0.5 -B 8M)
exclude=(--exclude '._*' --exclude '.DS_Store')

if [[ ! -e "${path}" ]]; then
  echo "Error: Path Not Found => ${path}" >&2
  exit 1
fi

if ! [[ "${ip}" =~ ^[0-9.]+$ ]]; then
  echo "Error: Invalid IP Format => ${ip}" >&2
  exit 1
fi

lastpart=$(basename "${path}")

if [[ -d "${path}" ]]; then
  bytes=$(du -sb "$path" | cut -f1)

  parentdir=$(dirname "${path}")
  stream() {
    printf "\n"
    tar "${exclude[@]}" -b"${blocks}" -cf- -C"${parentdir}" "${lastpart}"
  }
else
  size=$(stat -c%s "${path}")
  bytes=$((size + ${#lastpart} + 1))
  
  stream() {
    printf "%s\n" "${lastpart}"
    cat "${path}"
  }
fi

stream | pv "${flags[@]}" -s "${bytes}" | nc -N "${ip}" "${port}"
