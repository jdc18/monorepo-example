locals {
  name = "${var.app_name}-cluster-${terraform.workspace}"

  container_name = "${var.app_name}-backend-${terraform.workspace}"
  container_port = var.backend_port

  tags = {
    Name        = local.name
    Environment = terraform.workspace
  }

}

module "ecs_cluster" {
  source = "terraform-aws-modules/ecs/aws//modules/cluster"

  cluster_name = local.name

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/ecs/${local.name}"
      }
    }
  }

  autoscaling_capacity_providers = {
    backend_1 = {
      auto_scaling_group_arn         = module.autoscaling["backend_1"].autoscaling_group_arn
      managed_termination_protection = "ENABLED"

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

}
