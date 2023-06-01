terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.15"
    }
  }

  required_version = ">= 1.2.0"
}


# Create a ECR repository
resource "aws_ecr_repository" "ecr_repo" {
  name = var.ecr_repository_name
}

# Build Docker image and push it to ECR
resource "docker_registry_image" "ecr_repo" {
  name = "${aws_ecr_repository.ecr_repo.repository_url}:latest"


  build {
    context = "./app"
    dockerfile = "Dockerfile"
  }
}


resource "aws_ecs_task_definition" "task_definition" {
  family = "${var.ecr_repository_name}-task"
  container_definitions = <<DEFINITION
[
  {
    "name": "${var.ecr_repository_name}-container",
    "image": "${aws_ecr_repository.ecr_repo.repository_url}:latest",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80,
        "protocol": "tcp"
      }
    ],
    "memory": 128,
    "essential": true,
    "cpu": 128
  }
]
DEFINITION
}