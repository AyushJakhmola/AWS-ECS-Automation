module "ecs" {
  source = "terraform-aws-modules/ecs/aws"
  depends_on              = [module.asg]
  cluster_name = format("%s-%s-cluster", var.env, var.name)
  cluster_settings = {
  "name": "containerInsights",
  "value": "disabled"
}
  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/aws-ec2"
      }
    }
  }
  # Capacity provider - autoscaling groups
  autoscaling_capacity_providers = {
    one = {
      auto_scaling_group_arn         = module.asg["one"].autoscaling_group_arn
      # managed_termination_protection = "ENABLED"

      managed_scaling = {
        maximum_scaling_step_size = 5
        minimum_scaling_step_size = 1
        status                    = "ENABLED"
        target_capacity           = 60
      }

      default_capacity_provider_strategy = {
        weight = 60
        base   = 20
      }
    }
  }

  tags = {
    Environment = "stg"
  }
}

