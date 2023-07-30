#!/bin/bash

function usage() {
  cat <<EOF
Use this plugin like this:

  helm show-merged [helm template options]

EOF
  exit 0
}

for opt in "$@"; do
  case "$opt" in
    -h|--help)
      usage
      ;;
  esac
done

TEMPLATE_FILE=templates/final${RANDOM}.tpl

# Check current working directory for Chart.yaml
[[ ! -f Chart.yaml ]] && {
  echo "No Chart.yaml found."
  exit 1
}

cat <<EOF >$TEMPLATE_FILE
{{ .Values | toYaml }}
EOF

trap 'rm $TEMPLATE_FILE' EXIT

$HELM_BIN template . --disable-openapi-validation -s $TEMPLATE_FILE "$@" | tail -n +3
