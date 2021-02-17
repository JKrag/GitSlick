#!/usr/bin/env bash

CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
RC='\033[0m' # Reset Color

git config alias.chatlog "log --pretty=\"format:%C(green)%aN %C(blue)[%ad]%C(reset)%n%B\" --date=relative"

commands() {
  echo "Commands:"
  echo -e "${GREEN}/quit${RC}                  (to quit chat)"
  echo -e "${GREEN}/help${RC}                  (print list of supported commands)"
  echo -e "${GREEN}/switch <channel name>${RC} (to change #channel"
  echo -e "${GREEN}/create <channel name>${RC} (to create a new #channel)"
  echo -e "${GREEN}/list${RC}                  (to list channels)"
  echo -e "${GREEN}/repeat [n]${RC}            (repeat last n messages - default 5)"
  echo -e "${GREEN}/post${RC}                  (write a post aka. multiline message via your regular git message editor)"
}

welcome() {
  echo -e "${CYAN}Welcome to GitSlick, the Git based miniature chat app.${RC}"
  echo
  commands
  echo -e "Anything else is treated as a chat message. It will be commited to current dir git repo and pushed immediately to origin"
  echo -e "with NO safety checks or error handling".
  echo
  echo -e "NOTE: Currently only really supports single line messages. Behaviour undefined if pasting multiline content."
  echo -e "But you can now use the ${GREEN}/post${RC} feature if you want to send multiline content."
  echo
  echo -e "You are currenty in folder ${RED}$(pwd)${RC}"
  echo -e "And pushing to ${RED}$(git remote get-url origin --push)${RC}"
  echo
}

welcome

fetch_print_ff() {
  git fetch --quiet
  git chatlog "..@{u}"
  git merge --ff-only --quiet
}

fetch_print_ff
while true ; do
  while IFS=" " read -r -e -p "$(git branch --show-current)> " cm options; do
    fetch_print_ff
    echo
    if [ "$cm" = "" ]; then
      :
    elif [ "$cm" = "/quit" ]; then
      exit 0
    elif [ "$cm" = "/help" ]; then
      commands
      echo
    elif [ "$cm" = "/switch" ]; then
      git switch "$options"
      echo "Showing last 5 messages in $options"
      git chatlog -5
    elif [ "$cm" = "/list" ]; then
      echo -e "Existing channels: (use ${GREEN}/switch <channelname>${RC} to change channel"
      git branch -a
    elif [ "$cm" = "/create" ]; then
      echo "Creating new channel $options"
      git switch --quiet --orphan "$options"
      git commit --allow-empty --message "Beginning of Channel $options"
      git push --set-upstream --quiet origin "$options"
    elif [ "$cm" = "/repeat" ]; then
      : "${options:=5}"
      echo -e "Repeating last $options messages in ${RED}$(git branch --show-current)${RC}"
      git chatlog "-$options"
    elif [ "$cm" = "/post" ]; then
      git commit --quiet --allow-empty
      git chatlog -1
      git push --quiet origin
    else
      message="$cm $options"
      git commit --quiet --allow-empty --message "$message"
      git chatlog -1
      git push --quiet origin
    fi
  done
done
