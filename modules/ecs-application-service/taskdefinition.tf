# task defination 

resource "aws_ecs_task_definition" "service_defination" {
  family = var.task_definition_name
  container_definitions = data.template_file.json_template.rendered
  requires_compatibilities = var.require_compatibility
  execution_role_arn = aws_iam_role.task_execution_role.arn
  task_role_arn = aws_iam_role.task_execution_role.arn
  memory = 1024
  network_mode = "awsvpc"
}

data "template_file" "json_template" {
  template   = file("${path.module}/template.json")

  vars = {
     mongodb_image = "var.mongodb_image_uri"
     log_group = "/ecs/${var.container_name}"
     region = "us-east-1"
     container_name = var.container_name 
     container_port = 8080
     image_uri = "309017165673.dkr.ecr.us-east-1.amazonaws.com/public:rs-node"
     memory = 1024
  }
}

resource "aws_cloudwatch_log_group" "task_logs" {
  name = "/ecs/${var.container_name}"
}
