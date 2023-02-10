module "application_service" {
  source = "../../../modules/ecs-application-service"

    env = "dev" 

    repo_location = "https://github.com/AyushJakhmola/robot-shop.git"
    repo_name = "AyushJakhmola/robot-shop"
    branch_name = "master"

    task_definition_name = "catalogue"
    container_name = "catalogue"

    enable_load_balancing = false
    enable_cicd = true
    
    s3_bucket_name = module.s3_bucket.s3_bucket_id
    cluster_name = data.aws_ecs_cluster.ecs_info.cluster_name
    cluster_arn = data.aws_ecs_cluster.ecs_info.arn
    vpc_id = data.aws_vpc.ecs_vpc_id.id
    subnets = data.aws_subnets.subnet_ids.ids
    
    namespace_id = aws_service_discovery_private_dns_namespace.robotshop_namespace.id    
    
}

# NameSpace in Route 53
resource "aws_service_discovery_private_dns_namespace" "robotshop_namespace" {
  name        = "robotshop"
  description = "namespace"
  vpc         = data.aws_vpc.ecs_vpc_id.id
}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "apps-code-pipeline-bucket"
  acl    = "private"
  force_destroy = true

  versioning = {
    enabled = true
  }

}