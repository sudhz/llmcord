#!/bin/sh
set -eu

DEPLOY_PATH=${DEPLOY_PATH:?DEPLOY_PATH is required}
REPO_URL=${REPO_URL:?REPO_URL is required}
PYTHON_BIN=${PYTHON_BIN:-python3}

if ! command -v "$PYTHON_BIN" >/dev/null 2>&1; then
  printf '%s\n' "Python interpreter '$PYTHON_BIN' was not found" >&2
  exit 1
fi

mkdir -p "$(dirname -- "$DEPLOY_PATH")"

if [ ! -d "$DEPLOY_PATH/.git" ]; then
  mkdir -p "$DEPLOY_PATH"
  git -C "$DEPLOY_PATH" init
  git -C "$DEPLOY_PATH" remote add origin "$REPO_URL"
fi

git -C "$DEPLOY_PATH" fetch --depth 1 origin main
git -C "$DEPLOY_PATH" checkout -B main FETCH_HEAD

cd "$DEPLOY_PATH"
chmod +x scripts/start-service.sh scripts/deploy-remote.sh

if [ ! -x ".venv/bin/python" ]; then
  "$PYTHON_BIN" -m venv .venv
fi

".venv/bin/python" -m pip install --upgrade pip
".venv/bin/python" -m pip install -r requirements.txt
