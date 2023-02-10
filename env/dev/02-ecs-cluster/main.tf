module "ecs_cluster" {
  source = "../../../modules/ecs-cluster"

  env = "dev"
  name = "ecs"


  vpc_id = data.aws_vpc.ecs_vpc_id.id
  private_subnets = data.aws_subnets.subnet_ids.ids
  # data.aws_vpc.ecs_vpc_id.cidr_block

  cluster_instance_image_id = "ami-05e7fa5a3b6085a75" # from data
  cluster_instance_type = "t3a.medium"
  instance_key_name = "ayush-squareops"
  instance_volume_size = 30
  instance_volume_type = "gp2"
  min_size = 0
  max_size = 1
  desired_capacity = 1

}

