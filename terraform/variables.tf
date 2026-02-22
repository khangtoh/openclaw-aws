variable "aws_region" {
  type        = string
  description = "AWS region to deploy into."
  default     = "us-east-1"
}

variable "app_name" {
  type        = string
  description = "Name prefix for AWS resources."
  default     = "openclaw"
}

variable "image_tag" {
  type        = string
  description = "Docker image tag to deploy."
  default     = "latest"
}

variable "container_port" {
  type        = number
  description = "Container port OpenClaw listens on."
  default     = 8080
}

variable "desired_count" {
  type        = number
  description = "Number of ECS tasks."
  default     = 1
}

variable "cpu" {
  type        = number
  description = "CPU units for the task definition."
  default     = 512
}

variable "memory" {
  type        = number
  description = "Memory (MiB) for the task definition."
  default     = 1024
}

variable "health_check_path" {
  type        = string
  description = "Path used by the ALB health check."
  default     = "/"
}

variable "fargate_platform_version" {
  type        = string
  description = "Fargate platform version (backed by AWS-managed Firecracker microVM runtime)."
  default     = "LATEST"
}

variable "container_env" {
  type        = map(string)
  description = "Environment variables to pass to the container."
  default     = {}
}
