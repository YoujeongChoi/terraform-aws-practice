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

# aws_db_instance 리소스가 생성된 후 주소와 포트를 출력 변수로 설정
output "db_address" {
  value = aws_db_instance.example.address
  description = "Connect to the database at this endpoint"
}

output "db_port" {
  value = aws_db_instance.example.port
  description = "The port the database is listening on"
}

module "webserver_cluster" {
  source                  = "../../../modules/services/webserver-cluster"
  cluster_name            = var.cluster_name
  db_remote_state_bucket  = var.db_remote_state_bucket
  db_remote_state_key     = var.db_remote_state_key
  instance_type           = var.instance_type
  min_size                = var.min_size
  max_size                = var.max_size
  db_address              = aws_db_instance.example.address
  db_port                 = aws_db_instance.example.port
}
