#!/bin/bash

# Add ssh key for Github
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/github-docker

# Add Github to the know hosts
mkdir -p ~/.ssh
ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

# Change working dir
cd /aosp

# Start interactive shell
/bin/bash "$@"