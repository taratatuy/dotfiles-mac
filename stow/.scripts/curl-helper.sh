#!/bin/bash
set -euo pipefail

# The script expects execute_curl(), autologin() and print_usage() to be declared first.
# Example:
#
# request_body_required="true"
# execute_curl() {
#   local env="${1}" server="${2}" token="${3}" body="${4}"
#   local other_arg1="${5}" other_arg2="${6}"
#
#   url="https://${env}.${server}"
#
#   curl --location "${url}" \
#     -X "POST" \
#     -H "Authorization: ${token}" \
#     -d "@${body}"
# }
# autologin() {
#   local env="${1}" server="${2}"
#
#   local username="<username>"
#   local password="<password>"
#   local autologin_url="https://${env}.${server}"
#   local autologin_data="username=${username}&password=${password}&client_id=frontend&grant_type=password"
#
#   local autologin_response=$(curl --location-trusted "${autologin_url}" \
#     -X "POST" \
#     -H "content-type: application/x-www-form-urlencoded" \
#     -H "content-length: ${#autologin_data}" \
#     -d "${autologin_data}")
#
#   local autologin_token_type=$(echo "${autologin_response}" | jq -r '.token_type')
#   local autologin_access_token=$(echo "${autologin_response}" | jq -r '.access_token')
#   echo "${autologin_token_type} ${autologin_access_token}"
# }
# print_usage(){
#   echo "Usage: ${0} [-n|-a] mdc-01/env-1 [other_arg1 other_arg2 ...]"
# }
# source ~/.scripts/curl-helper.sh $@

tmp_folder="/tmp/curl"

build_response_file_name() {
  local script_file_name="${1}" tmp_folder="${2}" server="${3}" env="${4}" arguments="${5}"
  local current_time="$(perl -MTime::HiRes -E 'say int(Time::HiRes::time() * 1000)')"

  local response_file_name="${script_file_name#./}"
  local response_file_name="${response_file_name%.curl.sh}"
  local response_file_name="${response_file_name}.${server}_${env}.${arguments:-}.${current_time}.res.json"
  local response_file_name="${response_file_name// /_}"
  local response_file_name="${tmp_folder}/${response_file_name}"
  echo "${response_file_name}"
}

build_request_body_file_name() {
  local script_file_name="${1}" tmp_folder="${2}"

  local request_body_file_name="${script_file_name#./}"
  local request_body_file_name="${request_body_file_name%.curl.sh}"
  local request_body_file_name="${request_body_file_name}.body.json"
  local request_body_file_name="${request_body_file_name// /_}"
  local request_body_file_name="${tmp_folder}/${request_body_file_name}"
  echo "${request_body_file_name}"
}

for arg in "${@:-}"; do
  if [ "$arg" == "-n" ]; then
    set_new_token="true"
  elif [ "$arg" == "-a" ]; then
    autologin="true"
  else
    filtered_args+=("$arg")
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

if [ "${autologin:-}" == "true" ]; then
  token=$(autologin "${env}" "${server}")

elif [ "${set_new_token:-}" == "true" ]; then
  if [ -f "${env_token_file}" ]; then
    mv "${env_token_file}" "${env_token_file}.bkp"
  fi
  ${EDITOR} "${env_token_file}"
  if [ -f "${env_token_file}.bkp" ]; then
    if [ -f "${env_token_file}" ]; then
      rm "${env_token_file}.bkp"
    else
      mv "${env_token_file}.bkp" "${env_token_file}"
    fi
  fi
  token=$(<"${env_token_file}")

elif [ -f "${env_token_file}" ]; then
  token=$(<"${env_token_file}")

else
  ${EDITOR} "${env_token_file}"
  token=$(<"${env_token_file}")
fi

response_file_name=$(build_response_file_name "${0}" "${tmp_folder}" "${server}" "${env}" "${@:-}")

if [ "${request_body_required:-}" == "true" ]; then
  request_body_file_name=$(build_request_body_file_name "${0}" "${tmp_folder}")
  echo "--- Replace with request body ---" > "${request_body_file_name}"

  ${EDITOR} "${request_body_file_name}"
fi

execute_curl "${env}" "${server}" "${token}" "${request_body_file_name:-}" "${@:-}" > "${response_file_name}"

echo ""
echo "Url: ${url}"
echo ""
echo "Saved to ${response_file_name}"
${EDITOR} "${response_file_name}"

