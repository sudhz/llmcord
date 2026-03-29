#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
APP_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
VENV_PYTHON=${VENV_PYTHON:-"$APP_ROOT/.venv/bin/python"}

if [ ! -x "$VENV_PYTHON" ]; then
  printf '%s\n' "Python virtualenv is missing at $VENV_PYTHON. Run scripts/deploy-remote.sh first." >&2
  exit 1
fi

export PYTHONUNBUFFERED=${PYTHONUNBUFFERED:-1}

cd "$APP_ROOT"
exec "$VENV_PYTHON" llmcord.py
