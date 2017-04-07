#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# usage

usage() {
cat << EOF
Print out the helm environment.

Usage:
  helm env [OPTIONS]

Options:
      --vars-only      only print environment variables
  -q, --quiet          don't print headers

EOF

  exit
}

# -----------------------------------------------------------------------------
# rule
#
# Print a horizontal line the width of the terminal.

rule() {
  local cols="${COLUMNS:-$(tput cols)}"
  local char=$'\u2500'
  printf '%*s\n' "${cols}" '' | sed -n -r "s/ /${char}/gp"
}

# -----------------------------------------------------------------------------
# header
#
# Print step header text in a consistent way

header() {
  if [[ "${QUIET}" ]]; then
    return
  fi

  # If called with no args, assume the key is the caller's function name
  local msg="$*"
  printf "\n%s[%s]\n\n" "$(rule)" "${msg}"
}

# -----------------------------------------------------------------------------
# print_helm_envars
#
# Print helm related environment variables.

print_helm_envars() {
  header "Helm environment"
  env | sort | grep -e HELM_ -e TILLER_ -e KUBE_
}

# -----------------------------------------------------------------------------
# print_kubectl_config
#
# Print pertinent values from kubectl config.

print_kubectl_config() {
  header "kubectl config"

  local current_context server

  current_context=$(kubectl config current-context)
  server=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')

cat << EOF
current-context: ${current_context}
server:          ${server}
EOF
}

# -----------------------------------------------------------------------------
# parse command line options

ENVARS_ONLY=
QUIET=

while [[ $# -ne 0 ]]; do
  case "$1" in
    --vars-only) ENVARS_ONLY=1  ;;
    --quiet|-q)        QUIET=1  ;;
    -*)          usage "Unrecognized command line argument $1" ;;
    *)           break;
  esac
  shift
done

# -----------------------------------------------------------------------------
# main

print_helm_envars

if [[ ${ENVARS_ONLY} ]]; then
  exit
fi

print_kubectl_config
