#!/usr/bin/env bash
command -v gum >/dev/null 2>&1 || { echo >&2 "This advanced version og GitSlick requires Gum to be installed. Install Gum or use pure bash chat.sh instead."; exit 1; }

WIDTH=90
# https://www.ditig.com/256-colors-cheat-sheet
export GUM_INPUT_CURSOR_FOREGROUND=45 # 51=Cyan1
export GUM_INPUT_PROMPT_FOREGROUND=46 # 45=Turquoise2

WELCOME=$(gum style --width "$WIDTH" --align center --padding 1 --margin 0 --border double "Welcome to GitSlick, the Git based miniature chat app." )
C1=$(gum style --underline --bold 'Commands:')

git config alias.chatlog "log --reverse --pretty=\"format:%C(green)%aN %C(blue)[%ad]%C(reset)%n%B\" --date=relative"

get_local_branches () {
  git branch --format='%(refname:short)'
}

get_remote_branches () {
  git for-each-ref --format '%(refname:short)' refs/remotes |
  while read ref; do
      if ! git symbolic-ref -q "refs/remotes/$ref" > /dev/null; then
        echo $ref
    fi
  done
}

get_branches () {
  # help mapfile
  # -t	Remove a trailing DELIM from each line read (default newline)
  # -C callback	Evaluate CALLBACK each time QUANTUM lines are read
  # -c quantum	Specify the number of lines read between each call to CALLBACK
  # -O origin	Begin assigning to ARRAY at index ORIGIN.  The default index is 0
  # mapfile -O "${#BRANCHES[@]}" effecively appends to existing array as "${#BRANCHES[@]}" is the length of the current array
  mapfile -t BRANCHES < <( get_local_branches ) # if you want the branches that were sent to mapfile in a new array as well
  mapfile -t -O "${#BRANCHES[@]}" BRANCHES < <( get_remote_branches ) # if you want the branches that were sent to mapfile in a new array as well
  echo "${BRANCHES[@]}"
}

commands() {
  local C2 D2 C3 D3 C4 D4 C5 D5 C6 D6 C7 D7 C8 D8 COMMANDS DESCRIBS CMDTABLE
  C2=$(gum style --foreground '10' '/help')
  D2=$(gum style --italic '(print list of supported commands)')
  C3=$(gum style --foreground '14' '/list')
  D3=$(gum style --italic '(to list channels)' )
  C4=$(gum style --foreground '14' '/switch <channel name>')
  D4=$(gum style --italic '(to change #channel)')
  C5=$(gum style --foreground '14' '/create <channel name>')
  D5=$(gum style --italic '(to create a new #channel)')
  C6=$(gum style --foreground '14' '/repeat [n]')
  D6=$(gum style --italic '(repeat last n messages - default 5)')
  C7=$(gum style --foreground '14' '/post')
  D7=$(gum style --italic '(write a post aka. multiline message)')
  C8=$(gum style --foreground '9' '/quit or /exit')
  D8=$(gum style --italic '(to quit chat)')
  COMMANDS=$(gum style --align left --padding "0 1" --margin 0  "$C2" "$C3" "$C4" "$C5" "$C6" "$C7" "$C8")
  DESCRIBS=$(gum style --align left --padding "0 1" --margin 0  "$D2" "$D3" "$D4" "$D5" "$D6" "$D7" "$D8")
  CMDTABLE=$(gum join --horizontal  "$COMMANDS" "$DESCRIBS" )
  CMDBOX=$(gum style --width "$WIDTH" --border normal "$CMDTABLE")
  #echo "$CMDBOX"
}
commands

welcome() {
  gum join --vertical "$WELCOME" "$C1" "$CMDBOX"
  gum style --width "$WIDTH" --align left --padding "0 1" --margin "0 0" --border hidden \
    "Anything starting with a slash is a command. E.g. $(gum style --foreground '10' '/help')"\
    "Anything else is treated as a chat message. It will be commited to current dir git repo and pushed immediately to origin" \
    "with $(gum style --bold --foreground 9 "NO") safety checks or error handling."
  gum style --width "$WIDTH" --align left --padding "0 1" --margin "0 0" --border rounded  \
    "$(gum style --bold "NOTE"): Currently only really supports single line messages. Behaviour undefined if pasting multiline content." \
    "But you can now use the $(gum style --foreground '10' '/post') feature if you want to send multiline content."
  # gum style --width "$WIDTH" --align left --padding "0 1" --margin "0 0" --border normal \
  #   "NOTE: You can use $(gum style --foreground '10' '/repeat') to repeat last messages in current channel."
  gum style --width "$WIDTH" --align left --padding "0 1" --margin "0 0" --border hidden \
    "You are currently in folder $(gum style --foreground '14' "$(pwd)")" \
    "And pushing to $(gum style --foreground '14' "$(git remote get-url origin --push)")"
}

title(){
  BASE=$(basename -s .git "$(git config --get remote.origin.url)")
  BRANCH=$(git branch --show-current)
  TITLE="#$BRANCH @ $BASE"
  printf '\033]2;%s\a' "$TITLE"
  #printf "\[\e]2;%s\a\]"
}
welcome
title
fetch_print_ff() {
  gum spin --spinner dot --title Fetching -- git fetch --quiet
  git chatlog "..@{u}"
  git merge --ff-only --quiet
}

# fetch_print_ff
# while true ; do
#   while IFS=" " read -r -e -p "$(git branch --show-current)> " cm options; do
#     fetch_print_ff
#     echo
#     if [ "$cm" = "" ]; then
#       :
#     elif [ "$cm" = "/quit" ]; then
#       exit 0
#     elif [ "$cm" = "/exit" ]; then
#       exit 0
#     elif [ "$cm" = "/help" ]; then
#       echo "$CMDBOX"
#       echo
#     elif [ "$cm" = "/switch" ]; then
#       git switch "$options"
#       title
#       echo "Showing last 5 messages in $options"
#       git chatlog -5
#     elif [ "$cm" = "/list" ]; then
#       echo -e "Existing channels: (use ${GREEN}/switch <channelname>${RC} to change channel"
#       git branch -a
#     elif [ "$cm" = "/create" ]; then
#       echo "Creating new channel $options"
#       git switch --quiet --orphan "$options"
#       git commit --allow-empty --message "Beginning of Channel $options"
#       git push --set-upstream --quiet origin "$options"
#       title
#     elif [ "$cm" = "/repeat" ]; then
#       : "${options:=5}"
#       echo -e "Repeating last $options messages in ${RED}$(git branch --show-current)${RC}"
#       git chatlog "-$options"
#     elif [ "$cm" = "/post" ]; then
#       git commit --quiet --allow-empty
#       git chatlog -1
#       git push --quiet origin
#     else
#       message="$cm $options"
#       git commit --quiet --allow-empty --message "$message"
#       git chatlog -1
#       git push --quiet origin
#     fi
#   done
# done
