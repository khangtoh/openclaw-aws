#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  run_openclaw.sh local --openclaw-repo <path> [--port <port>] [--image-tag <tag>] [--detach]
  run_openclaw.sh aws   --region <region> --app-name <name> --image-tag <tag> --openclaw-repo <path>

Convenience wrapper to run OpenClaw locally (macOS Docker) or push image for AWS deployment.
USAGE
}

MODE="${1:-}"
if [[ -z "$MODE" ]]; then
  usage
  exit 1
fi
shift

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "$MODE" in
  local)
    "$SCRIPT_DIR/run_local_macos.sh" "$@"
    ;;
  aws)
    "$SCRIPT_DIR/build_and_push.sh" "$@"
    ;;
  -h|--help|help)
    usage
    ;;
  *)
    echo "Unknown mode: $MODE"
    usage
    exit 1
    ;;
esac
