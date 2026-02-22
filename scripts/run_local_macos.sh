#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: run_local_macos.sh --openclaw-repo <path> [--port <port>] [--image-tag <tag>] [--detach]

Builds and runs OpenClaw locally with Docker on macOS.
USAGE
}

OPENCLAW_REPO=""
PORT="8080"
IMAGE_TAG="openclaw-local:latest"
DETACH="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --openclaw-repo)
      OPENCLAW_REPO="$2"
      shift 2
      ;;
    --port)
      PORT="$2"
      shift 2
      ;;
    --image-tag)
      IMAGE_TAG="$2"
      shift 2
      ;;
    --detach)
      DETACH="true"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1"
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$OPENCLAW_REPO" ]]; then
  usage
  exit 1
fi

if [[ ! -d "$OPENCLAW_REPO" ]]; then
  echo "OpenClaw repo path not found: $OPENCLAW_REPO"
  exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is required. Install Docker Desktop for macOS first."
  exit 1
fi

pushd "$OPENCLAW_REPO" >/dev/null

docker build -t "$IMAGE_TAG" .

RUN_ARGS=(--rm -p "${PORT}:8080" "$IMAGE_TAG")
if [[ "$DETACH" == "true" ]]; then
  RUN_ARGS=( -d "${RUN_ARGS[@]}" )
fi

docker run "${RUN_ARGS[@]}"

popd >/dev/null

echo "OpenClaw local URL: http://localhost:${PORT}"
