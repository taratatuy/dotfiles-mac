#!/bin/bash
set -euo pipefail

# The script expects execute_curl() and print_usage() to be declared first.
# Example:
#
# execute_curl() {
#   local env="${1}" server="${2}" token="${3}" other_arg1="${4}"
#
#   url="https://${env}.${server}"
#
#   curl --location "${url}" \
#     -H "Authorization: ${token}"
# }
# print_usage(){
#   echo "Usage: ${0} [-n] mdc-01/env-1 [other_arg1 other_arg2 ...]"
# }
# source ~/.scripts/curl-helper.sh $@

tmp_folder="/tmp/curl"

for arg in "${@:-}"; do
  if [ "$arg" != "-n" ]; then
    filtered_args+=("$arg")
  else
    set_new_token="true"
  fi
done

set -- "${filtered_args[@]:-}"

if [ "${#}" == 0 ]; then
  echo "Error: Error while parsing the env route."
  print_usage
  exit  1
fi

IFS='/' read -ra env_routes <<< "${1}"
shift

if [ "${#env_routes[@]}" -lt 2 ]; then
  echo "Error: Error while parsing the env route."
  print_usage
  exit  1
fi

server="${env_routes[0]}"
env="${env_routes[1]}"
env_token_file="${tmp_folder}/${server}_${env}_token"

if [ ! -d "${tmp_folder}" ]; then
  mkdir "${tmp_folder}"
fi

if [ "${set_new_token:-}" == "true" ] && [ -f "${env_token_file}" ]; then
  mv "${env_token_file}" "${env_token_file}.bkp"
fi

if [ -f "${env_token_file}" ]; then
  token=$(<"${env_token_file}")
else
  ${EDITOR} "${env_token_file}"

  if [ ! -f "${env_token_file}" ] && [ -f "${env_token_file}.bkp" ]; then
    mv "${env_token_file}.bkp" "${env_token_file}"
  elif [ -f "${env_token_file}.bkp" ]; then
    rm "${env_token_file}.bkp"
  fi

  token=$(<"${env_token_file}")
fi

current_time="$(perl -MTime::HiRes -E 'say int(Time::HiRes::time() * 1000)')"
response_file_name=${0#./}
response_file_name=${response_file_name%.curl.sh}
response_file_name="${tmp_folder}/${response_file_name}.${server}_${env}.${@:-}.${current_time}.response"
response_file_name="${response_file_name// /_}"

execute_curl "${env}" "${server}" "${token}" "${@:-}" > "${response_file_name}"

echo ""
echo "Url: ${url}"
echo ""
echo "Saved to ${response_file_name}"
${EDITOR} "${response_file_name}"

