# 데이터베이스 인스턴스 생성 후 상태를 s3에 저장

provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_db_instance" "example" {
  identifier_prefix   = "terraform-mysql"
  engine              = var.db_engine
  allocated_storage   = var.db_allocated_storage
  instance_class      = var.db_instance_class
  skip_final_snapshot = true
  db_name             = var.db_name
  username            = var.db_username
  password            = var.db_password
}

module "webserver_cluster" {
  source                  = "../../../modules/services/webserver-cluster"
  cluster_name            = var.cluster_name
  db_remote_state_bucket  = var.db_remote_state_bucket
  db_remote_state_key     = var.db_remote_state_key
  instance_type           = var.instance_type
  min_size                = var.min_size
  max_size                = var.max_size
  db_address              = var.db_address
  db_port                 = var.db_port
}


