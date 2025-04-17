#!/bin/zsh

if [ -z "$2" ]; then
  echo "At least 2 arguments expected, but got $#" 
  echo "Usage: ./tmux-navigate <session-name> <session-path> [root-session-command] [[path command] ...]" 
  exit 1
fi

SESSION_NAME=$1
shift
SESSION_PATH=$1
shift
ROOT_SESSION_COMMAND=$1
shift

tmux has-session -t $SESSION_NAME &> /dev/null
if [ $? != 0 ]
then
  tmux new -s $SESSION_NAME -d -c "$SESSION_PATH" $ROOT_SESSION_COMMAND

  if [ $# -gt 0 ]; then
    for ((i=0; i < $#; i+=2)); do
      WINDOW_PATH="${@:$(($i+1)):1}"
      COMMAND_NAME="${@:$(($i+2)):1}"

      tmux new-window -t $SESSION_NAME -c "$WINDOW_PATH" $COMMAND_NAME
    done
  fi

  tmux switchc -t $SESSION_NAME:1
else
  tmux switchc -t $SESSION_NAME
fi

