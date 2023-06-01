variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "my-ecr-repo"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}