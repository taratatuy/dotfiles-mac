#!/bin/bash

if [ -z "$2" ]; then
  echo "Error: At least 2 arguments expected, but got $#" 
  echo "Usage: ./tmux-navigate session-name tab-path [tab-command] [[tab-path [tab-command]] ...]" 
  exit 1
fi

session_name=$1; shift
first_path=$1; shift
first_command=$1; shift 2> /dev/null

tmux has-session -t $session_name &> /dev/null
if [ $? -eq 0 ]; then
  tmux switchc -t $session_name
  exit 0
fi

if [ ! -d $first_path ]; then
  echo "Error: Directory does not exist: $first_path"
  exit 2
fi

tmux new -s $session_name -d -c "$first_path" $first_command

if [ $# -gt 0 ]; then
  for ((i=0; i < $#; i+=2)); do
    window_path="${@:$(($i+1)):1}"
    window_command="${@:$(($i+2)):1}"

    if [ ! -d $window_path ]; then
      echo "Warn: Tab skipped. Directory does not exist: $first_path"
      sleep 2
      break
    fi

    tmux new-window -t $session_name -c "$window_path" $window_command
  done
fi

tmux switchc -t $session_name:1

