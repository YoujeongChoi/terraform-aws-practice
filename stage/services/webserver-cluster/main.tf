provider "aws" {
  region = "ap-northeast-2"
}

# 웹 서버 클러스터 설정
module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"
  cluster_name = "webserver-stage"
  db_remote_state_bucket = var.db_remote_state_bucket
  db_remote_state_key = var.db_remote_state_key
  instance_type = "t3.micro"
  min_size = 1
  max_size = 2
  db_address = data.terraform_remote_state.db.outputs.address
  db_port = data.terraform_remote_state.db.outputs.port
}

# 보안 그룹 규 (인바운드)
resource "aws_security_group_rule" "allow_testing_inbound" {
  # 인바운드 트래픽 허용
  type = "ingress"
  # webserver_cluster 모듈에서 생성된 ALB 보안 그룹 id 사용
  security_group_id = module.webserver_cluster.alb_security_group_id
  # 허용 포트 범위
  from_port = var.sg_from_port
  to_port = var.sg_to_port
  protocol = "tcp"
  # 모든 Ip 에서 오는 트래픽 허용
  cidr_blocks = ["0.0.0.0/0"]
}
