#!/bin/bash
set -euo pipefail

input_file_name="${1:-}"
output_file_name="${2:-}"

if [ -z "${input_file_name}" ]; then
  echo "Usage: ./convert-mov-to-mp4.sh <input_name> [<output_name>]"
  exit 1
fi

if [ ! -f "${input_file_name}" ]; then
  echo "Error: No file found ${input_file_name}"
  exit 1
fi

if [ -z "${output_file_name}" ]; then
  output_file_name="${input_file_name%.mov}.mp4"
  output_file_name="${output_file_name// /_}"
fi

ffmpeg -i "${input_file_name}" -vcodec libx264 -acodec aac "${output_file_name}"
