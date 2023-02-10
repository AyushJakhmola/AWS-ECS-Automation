locals {
  enable_load   = var.enable_load_balancing == false ? [] : [1]
}

resource "aws_service_discovery_service" "service_record" {
  name = var.task_definition_name

  dns_config {
    namespace_id = var.namespace_id

    dns_records {
      ttl  = 10
      type = "A"
    }
  }
}

resource "aws_ecs_service" "service" {
  name            = var.task_definition_name
  cluster         =  var.cluster_arn
  task_definition = aws_ecs_task_definition.service_defination.arn
  desired_count   = 1
  launch_type = "EC2"
  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
  network_configuration {
    subnets          = var.subnets
    assign_public_ip = false
    security_groups = [aws_security_group.service_sg.id]
  }
  service_registries {
    registry_arn = aws_service_discovery_service.service_record.arn
  }
  
  dynamic "load_balancer" {
    for_each = local.enable_load
    content {
      target_group_arn      = var.enable_load_balancing ? module.app_alb[0].target_group_arns[0] : null
      container_name = var.container_name
      container_port         = 8080
    }
  }

}

resource "aws_security_group" "service_sg" {
  name        = format("%s-%s-sg", var.env, var.container_name)
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

