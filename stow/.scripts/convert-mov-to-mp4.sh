#!/bin/bash
if [ -z $2 ]; then
  echo "Usage: ./convert-mov-to-mp4.sh <input_name> <output_name>"
  exit 1
fi

ffmpeg -i "$1" -vcodec libx264 -acodec aac "$2"
