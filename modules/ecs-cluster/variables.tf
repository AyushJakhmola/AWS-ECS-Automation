variable "env" {
  description = "envronment"
  default = "dev"
}

variable "name" {
  description = "name of the resources"
}

variable "min_size" {
  description = "min_size"
  default     = 0
}

variable "max_size" {
  description = "max_size"
  default     = 7
}

variable "desired_capacity" {
  description = "desired_capacity"
  default     = 7
}

variable "cluster_instance_image_id" {
  description = "cluster_instance_image_id"
  default     = "ami-05e7fa5a3b6085a75"
}

variable "cluster_instance_type" {
  description = "cluster_instance_type"
  default     =  "t3a.medium"
}

variable "instance_key_name" {
  description = "instance_key_name"
  default     =  "ayush-squareops"
}

variable "instance_volume_size" {
  description = "volume_size"
  default     =  30
}

variable "instance_volume_type" {
  description = "volume_type"
  default     =  "gp2"
}

variable "private_subnets" {
  description = "subnet ids for asg"
}

variable "vpc_id" {
  description = "id of vpc"
}

