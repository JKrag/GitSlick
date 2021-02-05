#!/usr/bin/env bash
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
RC='\033[0m' # Reset Color
echo -e "${CYAN}Welcome to GitSlick, the Git based miniature chat app.${RC}"
echo
echo "Commands:"
echo -e "${GREEN}/quit${RC}                  (to quit chat)"
echo -e "${GREEN}/switch <channel name>${RC} (to change #channel"
echo -e "${GREEN}/create <channel name>${RC} (to create a new #channel)"
echo -e "${GREEN}/list${RC}                  (to list channels)"
echo -e "${GREEN}/repeat [n]${RC}            (repeat last n messages - default 5)"
echo "Anything else is treated as a chat message. It will be commited to current dir git repo and pushed immediately to origin"
echo "with NO safety checks or error handling".
echo
echo "NOTE: Currently only really supports single line messages. Behaviour undefined if pasting multiline content."
echo
echo -e "You are currenty in folder ${RED}$(pwd)${RC}"
echo -e "And pushing to ${RED}$(git remote get-url origin --push)${RC}"
echo
git fetch --quiet
git log --pretty="format:%C(green)%aN %C(blue)[%ad]%C(reset)%n%B" --date=relative ..@{u}
git merge --ff-only --quiet
while true ; do
  while IFS=" " read -r -e -p "$(git branch --show-current)> " cm options; do
    #echo "[$cm] [$options]"
    git fetch --quiet
    git log --pretty="format:%C(green)%aN %C(blue)[%ad]%C(reset)%n%B" --date=relative ..@{u}
    git merge --ff-only --quiet
    echo 
    if [ "$cm" = "" ]; then
      :
    elif [ "$cm" = "/quit" ]; then
      exit 0
    elif [ "$cm" = "/switch" ]; then
      git switch --quiet "$options"
      echo "Showing last 5 messages in $options"
      git log -5 --pretty="format:%C(green)%aN %C(blue)[%ad]%C(reset)%n%B" --date=relative
    elif [ "$cm" = "/list" ]; then
      echo -e "Existing channels: (use ${GREEN}/switch <channelname>${RC} to change channel"
      git branch -a
    elif [ "$cm" = "/create" ]; then
      echo "Creating new channel $options"
      git switch --quiet --orphan "$options"
      git commit --allow-empty --message "Beginning of Channel $options"
      git push --set-upstream origin "$options"
    elif [ "$cm" = "/repeat" ]; then
      : "${options:=5}" 
      echo -e "Repeating last $options messages in ${RED}$(git branch --show-current)${RC}"
      git log "-$options" --pretty="format:%C(green)%aN %C(blue)[%ad]%C(reset)%n%B" --date=relative
    else
      message="$cm $options"
      git commit --quiet --allow-empty --message "$message"
      git log -1 --pretty="format:%C(green)%aN %C(blue)[%ad]%C(reset)%n%B" --date=relative 
      git push --quiet origin
    fi
  done
done