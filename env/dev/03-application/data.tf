  data "aws_vpc" "ecs_vpc_id" {
  filter {
    name   = "tag:Name"
    values = ["ec2-vpc"]
  }
}

data "aws_subnets" "subnet_ids" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.ecs_vpc_id.id]
  }
    filter {
    name   = "tag:Name"
    values = ["public"] 
  }
}

data "aws_ecs_cluster" "ecs_info" {
  cluster_name = "dev-ecs-cluster"
}