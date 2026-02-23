#!/usr/bin/env bash
# oll template - Manage custom Ollama Modelfiles

TEMPLATE_DIR="/Users/gabz/.config/flake/ollama-templates"

action="${1:-list}"

case "$action" in
create)
  # Create single custom model from template
  template_name="$2"
  if [[ -z $template_name ]]; then
    echo "Usage: oll template create <template-name>"
    echo "Available templates:"
    ls -1 "$TEMPLATE_DIR"/*.Modelfile 2>/dev/null | xargs -n1 basename | sed 's/.Modelfile$//'
    exit 1
  fi

  modelfile="$TEMPLATE_DIR/${template_name}.Modelfile"
  if [[ ! -f $modelfile ]]; then
    echo "Error: Template not found: $modelfile"
    exit 1
  fi

  echo "Creating model: $template_name"
  ollama create "$template_name" -f "$modelfile"
  echo "✓ Model created: $template_name"
  ;;

apply)
  # Apply all templates
  echo "Creating all custom models from templates..."
  for modelfile in "$TEMPLATE_DIR"/*.Modelfile; do
    [[ ! -f $modelfile ]] && continue
    template_name=$(basename "$modelfile" .Modelfile)
    echo ""
    echo "Creating: $template_name"
    ollama create "$template_name" -f "$modelfile" || echo "⚠ Failed: $template_name"
  done
  echo ""
  echo "✓ Template application complete"
  echo "Run 'oll model list' to verify"
  ;;

list)
  # List available templates
  echo "Available templates in $TEMPLATE_DIR:"
  echo ""
  if ls "$TEMPLATE_DIR"/*.Modelfile &>/dev/null; then
    for modelfile in "$TEMPLATE_DIR"/*.Modelfile; do
      name=$(basename "$modelfile" .Modelfile)
      base=$(grep "^FROM" "$modelfile" | cut -d' ' -f2)
      echo "  • $name (base: $base)"
    done
  else
    echo "  No templates found"
  fi
  ;;

*)
  echo "Usage: oll template {apply|create|list}"
  echo ""
  echo "Commands:"
  echo "  apply              Create all models from templates"
  echo "  create <name>      Create specific model"
  echo "  list               Show available templates"
  exit 1
  ;;
esac
