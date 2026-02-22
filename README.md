# OpenClaw deployment options: AWS (Fargate/Firecracker) and local macOS

This repository now supports two ways to run OpenClaw:

1. **AWS deployment** on ECS Fargate (AWS-managed Firecracker microVM runtime).
2. **Local macOS run** using Docker Desktop.

## Prerequisites

- Docker (for both local and image builds).
- OpenClaw source code (clone https://github.com/openclaw/openclaw).
- For AWS mode only:
  - AWS account/credentials configured (`aws configure`).
  - Terraform >= 1.5.

## Option A: Run locally on macOS

Use this for development and quick testing.

```bash
./scripts/run_local_macos.sh \
  --openclaw-repo /path/to/openclaw \
  --port 8080 \
  --image-tag openclaw-local:latest
```

Then open:

```text
http://localhost:8080
```

You can also use the wrapper script:

```bash
./scripts/run_openclaw.sh local --openclaw-repo /path/to/openclaw --port 8080
```

## Option B: Deploy to AWS (ECS Fargate on Firecracker)

1. **Build and push image to ECR**

   ```bash
   ./scripts/build_and_push.sh \
     --region us-east-1 \
     --app-name openclaw \
     --image-tag latest \
     --openclaw-repo /path/to/openclaw
   ```

   Or via wrapper:

   ```bash
   ./scripts/run_openclaw.sh aws \
     --region us-east-1 \
     --app-name openclaw \
     --image-tag latest \
     --openclaw-repo /path/to/openclaw
   ```

2. **Deploy infrastructure**

   ```bash
   cd terraform
   terraform init
   terraform apply -auto-approve \
     -var="aws_region=us-east-1" \
     -var="app_name=openclaw" \
     -var="image_tag=latest" \
     -var="container_port=8080"
   ```

3. **Access OpenClaw**

   Terraform outputs `alb_dns_name`.

## Terraform configuration

Common variables in `terraform/variables.tf`:

- `container_port`
- `desired_count`
- `cpu` / `memory`
- `container_env`
- `health_check_path`
- `fargate_platform_version`

## Teardown AWS resources

```bash
cd terraform
terraform destroy
```
