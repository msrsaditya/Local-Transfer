#!/usr/bin/env bash
set -euo pipefail

path="${1}"
ip="${2}"
port=64943
blocks=8192
flags=(-f -b -t -r -a -p -i 0.5 -e -B 8M -k)
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
  bytes=$(stat -c%s "${path}")
  
  stream() {
    printf "%s\n" "${lastpart}"
    cat "${path}"
  }
fi

stream | pv "${flags[@]}" -s "${bytes}" | nc -N "${ip}" "${port}"
