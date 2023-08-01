#!/bin/bash

# vars
# set this to 1 if all templates should be temporary be deleted
NO_TEMPLATES=0

# the template file which will contain our code
TEMPLATE_FILE=templates/final${RANDOM}.tpl

# the workdir to use
WORKDIR=.

function usage() {
  cat <<EOF
Use this plugin like this:

  helm show-merged [plugin options] [helm template options]

  plugin options may be:
    -h|--help       show this help message
    --no-templates  dont render any other templates

EOF
  exit 0
}

for opt in "$@"; do
  case "$opt" in
    --no-templates)
      NO_TEMPLATES=1
      shift
      ;;
    -h|--help)
      usage
      ;;
  esac
done

# Check current working directory for Chart.yaml
[[ ! -f Chart.yaml ]] && {
  echo "No Chart.yaml found."
  exit 1
}

if [[ $NO_TEMPLATES -eq 1 ]]; then
  WORKDIR="$(mktemp -d)"
  # copy everything to workdir
  cp -r . "${WORKDIR}/"
  # remove templates
  find "$WORKDIR" -type d -path "*/templates/*.yaml"
  # clean up
  trap 'rm -rf $WORKDIR' EXIT
  # switch to workdir
  cd "$WORKDIR" || exit 1
else
  trap 'rm $TEMPLATE_FILE' EXIT
fi

cat <<EOF >"${WORKDIR}/${TEMPLATE_FILE}"
{{ .Values | toYaml }}
EOF

$HELM_BIN template . --disable-openapi-validation -s $TEMPLATE_FILE "$@" | sed '2d'
