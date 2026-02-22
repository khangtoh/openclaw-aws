#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: build_and_push.sh --region <region> --app-name <name> --image-tag <tag> --openclaw-repo <path>

Builds the OpenClaw Docker image from the provided repo path, creates/logs into ECR, and pushes the image.
USAGE
}

AWS_REGION=""
APP_NAME=""
IMAGE_TAG=""
OPENCLAW_REPO=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --region)
      AWS_REGION="$2"
      shift 2
      ;;
    --app-name)
      APP_NAME="$2"
      shift 2
      ;;
    --image-tag)
      IMAGE_TAG="$2"
      shift 2
      ;;
    --openclaw-repo)
      OPENCLAW_REPO="$2"
      shift 2
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

if [[ -z "$AWS_REGION" || -z "$APP_NAME" || -z "$IMAGE_TAG" || -z "$OPENCLAW_REPO" ]]; then
  usage
  exit 1
fi

if [[ ! -d "$OPENCLAW_REPO" ]]; then
  echo "OpenClaw repo path not found: $OPENCLAW_REPO"
  exit 1
fi

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_URI="${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
REPO_URI="${ECR_URI}/${APP_NAME}"

aws ecr describe-repositories --repository-names "$APP_NAME" --region "$AWS_REGION" >/dev/null 2>&1 || \
  aws ecr create-repository --repository-name "$APP_NAME" --region "$AWS_REGION" >/dev/null

aws ecr get-login-password --region "$AWS_REGION" | \
  docker login --username AWS --password-stdin "$ECR_URI"

pushd "$OPENCLAW_REPO" >/dev/null

docker build -t "${APP_NAME}:${IMAGE_TAG}" .
docker tag "${APP_NAME}:${IMAGE_TAG}" "${REPO_URI}:${IMAGE_TAG}"
docker push "${REPO_URI}:${IMAGE_TAG}"

popd >/dev/null

echo "Pushed ${REPO_URI}:${IMAGE_TAG}"
