provider "aws" {
  region = "ap-northeast-2"
}

module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"
  cluster_name = var.prod_cluster_name
  db_remote_state_bucket = var.db_remote_state_bucket
  db_remote_state_key = var.db_remote_state_key
  instance_type = var.prod_instance_size
  min_size = var.prod_as_min_size
  max_size = var.prod_as_max_size
  db_address = data.terraform_remote_state.db.outputs.address
  db_port = data.terraform_remote_state.db.outputs.port
}

# 오토스케일링 스케줄 설정 - 업무 시간 동안 확장
resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name  = var.prod_busniess_scheduled_action_name
  min_size               = var.prod_as_min_size
  max_size               = var.prod_as_max_size
  desired_capacity       = var.prod_as_desired_capacity
  recurrence             = "0 9 * * *"
  autoscaling_group_name = module.webserver_cluster.asg_name
}

# 오토스케일링 스케줄 설정 - 야간 축소
resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name  = var.prod_night_scheduled_action_name
  min_size               = var.prod_as_min_size
  max_size               = var.prod_as_max_size
  desired_capacity       = var.prod_as_desired_capacity
  recurrence             = "0 17 * * *"
  autoscaling_group_name = module.webserver_cluster.asg_name
}
