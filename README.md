# Helm Merged Plugin

Show all merged values.

## Description

This plugins adds a temporary template which contains `{{ .Values | toYaml }}`.
It's helpful if you want to see the end result of all the merged yaml files.

## Usage

```bash
# you probably want this
helm show-merged

# every other parameter besides -h/--help/--no-templates will be added to the helm template command.
# so you can:

# add custom yaml files
helm show-merged -f foo.yaml

# run debug mode
helm show-merged --debug

# disable any other template rendering
helm show-merged --no-templates
```

## install

```bash
helm plugin install https://github.com/dadav/helm-merged
```
