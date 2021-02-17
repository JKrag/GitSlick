#!/usr/bin/env bash

usage() {
  echo "Usage: $0 -r <REPOSITORY> -e <user.email> -n <user.name>"
  echo "Usage: $0 -h"
  echo "Note: REPOSITORY is the remote repo that you use to keep your GitSlick chat history"
  echo
  echo "Example: $0 -r https://github.com/JKrag/MySlick -e <me@localhost> -n \"My name\""
  exit 1;
}

while getopts r:e:n:h option; do
  case "${option}"
    in
      r) REPOSITORY=${OPTARG};;
      e) EMAIL=${OPTARG};;
      n) NAME=${OPTARG};;
      h) usage;;
      *) usage;;
  esac
done


# To be Windows compatible, we volume mount ssh keys to /tmp/.ssh and move them here
# instead of mounting directly to ~/.ssh. For more info see: 
# https://nickjanetakis.com/blog/docker-tip-56-volume-mounting-ssh-keys-into-a-docker-container
cp -R /tmp/.ssh /root/.ssh
chmod 700 /root/.ssh
chmod 644 /root/.ssh/id_rsa.pub
chmod 600 /root/.ssh/id_rsa

git config --global user.name "$NAME"
git config --global user.email "$EMAIL"
#git config core.sshCommand 'ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no' 
git config --global core.sshCommand 'ssh -o StrictHostKeyChecking=no' 

#echo "CHAT REPO: $REPOSITORY"
git clone -q "$REPOSITORY" chat
cd chat || exit
../chat.sh
