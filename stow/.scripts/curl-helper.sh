#!/bin/bash
set -euo pipefail

# The script expects execute_curl to be declared first.
# Example:
#
# execute_curl() {
#   local env="${1}" server="${2}" token="${3}"
#
#   url="https://${env}.${server}"
#
#   curl --location "${url}" \
#     -H "Authorization: ${token}"
# }
#
# source ~/.scripts/curl-helper.sh $@

tmp_folder="/tmp/curl"

if [ "${1:-}" == "-n" ]; then
  set_new_token="true"
  shift 1
fi

if [ -z "${1:-}" ]; then
  echo "Error: Error while parsing the env route."
  echo "Usage: ./curl-helper.sh [-n] mdc-01/env-1"
  exit  1
fi

IFS='/' read -ra env_routes <<< "${1}"

if [ "${#env_routes[@]}" -lt 2 ]; then
  echo "Error: Error while parsing the env route."
  echo "Usage: ./curl-helper.sh [-n] mdc-01/env-1"
  exit  1
fi

server="${env_routes[0]}"
env="${env_routes[1]}"

if [ ! -d "${tmp_folder}" ]; then
  mkdir "${tmp_folder}"
fi

if [ "${set_new_token:-}" == "true" ] && [ -f "${tmp_folder}/curl_token" ]; then
  mv "${tmp_folder}/curl_token" "${tmp_folder}/curl_token.bkp"
fi

if [ -f "${tmp_folder}/curl_token" ]; then
  token=$(<"${tmp_folder}/curl_token")
else
  ${EDITOR} "${tmp_folder}/curl_token"

  if [ ! -f "${tmp_folder}/curl_token" ] && [ -f "${tmp_folder}/curl_token.bkp" ]; then
    mv "${tmp_folder}/curl_token.bkp" "${tmp_folder}/curl_token"
  elif [ -f "${tmp_folder}/curl_token.bkp" ]; then
    rm "${tmp_folder}/curl_token.bkp"
  fi

  token=$(<${tmp_folder}/curl_token)
fi

current_time="$(perl -MTime::HiRes -E 'say int(Time::HiRes::time() * 1000)')"
file_name="${tmp_folder}/${0}-${current_time}.response"

execute_curl "${env}" "${server}" "${token}" > "${file_name}"

echo ""
echo "Url: ${url}"
echo ""
echo "Saved to ${file_name}"
${EDITOR} "${file_name}"

