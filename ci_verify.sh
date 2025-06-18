#!/bin/sh
set -e

install_git_hook() {
    local _hook=".git/hooks/$1"
    if [ -e "$_hook" ]; then
      echo "$_hook already exists"
      exit 1
    fi
    ln -s $(realpath ci_verify.sh) $_hook
    echo "linked ci_verify.sh to $_hook"
    exit 0
}

for arg in "$@"; do
  case $arg in
    "--on-git-commit")
      install_git_hook pre-commit;;
    "--on-git-push")
      install_git_hook pre-push;;
  esac
done

if ! command -v "pnpm" &> /dev/null; then
  _url="https://pnpm.io/installation"
  echo "\033[31merror:\033[0m pnpm is required for contributing\n\n  $_url\n"
fi

# validate local github workflow changes on commit or ./ci_verify.sh

validate_gh_wf_if_changed() {
    _changes=$(git status)
    if echo "$_changes" | grep -Eq "\.github/workflows/.*?\.ya?ml"; then
        model-t .
    fi
}

if [ "$0" = ".git/hooks/pre-commit" ]; then
    validate_gh_wf_if_changed
fi

if echo "$0" | grep -q "ci_verify\.sh$"; then
    validate_gh_wf_if_changed
fi

# validate committed github workflow changes on push

if [ "$0" = ".git/hooks/pre-push" ]; then
    read -a _input
    _changes=$(git diff --name-only ${_input[1]} ${_input[3]})
    if echo "$_changes" | grep -Eq "^\.github/workflows/.*?\.ya?ml$"; then
        model-t .
    fi
fi

# run through all the checks done for ci

flutter test
flutter analyze
dart format lib test --set-exit-if-changed
