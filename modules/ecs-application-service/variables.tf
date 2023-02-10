variable "env" {
  description = "envronment"
  default = "dev"
}

variable "repo_location" {
  description = "full path of the repository"
}

variable "s3_bucket_name" {
  description = "name of s3 bucket to store artifacts"
  default = "app-code-pipeline-bucket"
}

variable "repo_name" {
  description = "repository/directory"
}

variable "branch_name" {
  description = "name of the branch"
}

variable "cluster_name" {
  description = "name of the ecs cluster"
}

variable "task_definition_name" {
  description = "A unique name for your task definition"
}

variable "require_compatibility" {
  description = "Set of launch types required by the task.The valid values are EC2 and FARGATE."
  default = ["EC2"]
}

variable "namespace_id" {
  description = "id of the cloud map namespace"
}

variable "cluster_arn" {
  description = "arn of the cluster"
}

variable "vpc_id" {
  description = "id of vpc"
}

variable "container_name" {
  description = "name of the container"
}

variable "enable_load_balancing" {
  description = "enble load banacing"
}

variable "subnets" {
  description = "subnet cidr for alb"
}

variable "enable_cicd" {
  description = "enble cicd for the application"
}

# variable "servers" {
#   type = map(string)
#   default = {
#  MONGO_URL = "mongodb://robot:asdfghjkl123@mongodb.robotshopecs/admin"
#   }
# }