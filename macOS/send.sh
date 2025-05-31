#!/usr/bin/env bash
set -euo pipefail

export COPYFILE_DISABLE=1

path="${1}"
ip="${2}"
port=64943
flags=(-f -b -t -r -a -p -i 0.5 -e --si)

if [[ ! -e "${path}" ]]; then
  echo "Error: File Not Found => ${path}" >&2
  exit 1
fi

if ! [[ "${ip}" =~ ^[0-9.]+$ ]]; then
  echo "Error: Invalid IP format => ${ip}" >&2
  exit 1
fi

basepath=$(basename "${path}")

if [[ -d "${path}" ]]; then
  dirpath=$(dirname "${path}")
  filename=""
  
  size=$(du -sk "${path}")
  bytes=${size%%[[:space:]]*}
  bytes=$((bytes * 1024))
  
  stream() {
    tar --exclude='._*' --exclude='.DS_Store' -cpf - \
      -C "${dirpath}" \
      "${basepath}"
  }

else
  filename="${basepath}"
  
  if [[ "${filename}" != "${filename##*/}" ]] || [[ "${filename}" =~ \.\./ ]]; then
    echo "Error: Invalid Filename => ${filename}" >&2
    exit 1
  fi
  
  bytes=$(stat -f%z "${path}")
  
  stream() {
    cat "${path}"
  }
fi

{
  printf "%s\n%s\n" "${filename}" "${bytes}"
  stream | pv "${flags[@]}" -s "${bytes}"
} | nc "${ip}" "${port}"
