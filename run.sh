#!/usr/bin/env zsh

# Must have docker buildx to use buildkit=1.  Please use ./buildx.sh to perform this.

# Then store github repo "<username>/<repo-name>" (without quotes) and PAT, also without quotes, in files called "repo.txt" and "token.txt"
DOCKER_BUILDKIT=1 docker build --secret id=TOKEN,src=token.txt --secret id=REPO,src=repo.txt .