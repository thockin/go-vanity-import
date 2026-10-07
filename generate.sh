#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

# Define the target GitHub Organization
ORG="agent-substrate"

find . -mindepth 1 -maxdepth 1 -type d \
    | grep -v '.git' \
    | while read -r dir; do
        rm -rf "${dir}"
    done

curl -fsSL \
    -H "Accept: application/vnd.github+json" \
    "https://api.github.com/orgs/${ORG}/repos?per_page=100" \
    | jq -r '.[].name' \
    | while read -r repo_name; do
        echo "${repo_name}"
        mkdir "${repo_name}"
        sed "s/REPO/${repo_name}/g" in.tmpl > "${repo_name}/index.html"
    done
