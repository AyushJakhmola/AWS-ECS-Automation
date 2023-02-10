locals {
  user_data = <<EOF
  #!/bin/bash
  echo ECS_CLUSTER=${format("%s-%s-cluster", var.env, var.name)} >> /etc/ecs/ecs.config;echo ECS_BACKEND_HOST= >> /etc/ecs/ecs.config;
  EOF
}

module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"
   for_each = {
    one = {
      instance_type = var.cluster_instance_type
    }
   } 
  # Autoscaling group
  name = format("%s-%s-asg", var.env, var.name)

  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = var.private_subnets
  
  # Launch template
  launch_template_name        = format("%s-%s-launcg-template", var.env, var.name)
  launch_template_description = "Launch template for ec2 ecs"
  update_default_version      = true

  image_id                    = var.cluster_instance_image_id
  instance_type               = var.cluster_instance_type
  key_name                    = var.instance_key_name
  user_data         = base64encode(local.user_data)
  create_iam_instance_profile = true
  iam_role_name               = format("%s-%s-ecs-instance-role", var.env, var.name)
  iam_role_description        = "ECS role for ecs-role-ec2"
  iam_role_policies = {
    AmazonEC2ContainerServiceforEC2Role = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
    # AmazonSSMManagedInstanceCore        = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = var.instance_volume_size
        volume_type           = var.instance_volume_type
      }
      }
  ]
  network_interfaces = [
    {
      delete_on_termination = true
      description           = "eth0"
      device_index          = 0
      security_groups       = [aws_security_group.ec2_ecs_sg.id]
    }
  ]

  tags = {
    Environment = "stg"
  }
}