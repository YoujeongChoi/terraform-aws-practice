# ALB를 위한 보안 그룹 생성
resource "aws_security_group" "alb" {
  name = "${var.cluster_name}-alb"
}

# ALB 보안 그룹에 HTTP 수신 규칙 추가
resource "aws_security_group_rule" "allow_http_inbound" {
  type = "ingress"
  security_group_id = aws_security_group.alb.id
  from_port = local.http_port
  to_port = local.http_port
  protocol = local.tcp_protocol
  cidr_blocks = local.all_ips
}

# ALB 보안 그룹에 모든 트래픽에 대한 송신 규칙 추가
resource "aws_security_group_rule" "allow_all_outbound" {
  type = "egress"
  security_group_id = aws_security_group.alb.id
  from_port = local.any_port
  to_port = local.any_port
  protocol = local.any_protocol
  cidr_blocks = local.all_ips
}

# 애플리케이션 로드 밸런서 생성
resource "aws_lb" "example" {
  name = "${var.cluster_name}-asg-example"
  load_balancer_type = "application"
  subnets = data.aws_subnets.default.ids
  security_groups = [aws_security_group.alb.id]
}

# 로드 밸런서의 HTTP 리스너 생성
/*
HTTP 리스너 - 웹 애플리케이션으로부터 HTTP 요청 처리, 트래픽 분산
*/
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port = local.http_port
  protocol = "HTTP"

  # 기본 액션 - 404 반환
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code = 404
    }
  }
}

# 로드 밸런서 리스너 규칙 생성
/*
리스너 규칙 - 리스너가 특정 조건을 만족하는 요청에 대해 수행할 액션 정의
*/
resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority = 100
  condition {
    path_pattern {
      values = ["*"]
    }
  }
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}

# 로드 밸런서 타겟 그룹 생성
resource "aws_lb_target_group" "asg" {
  name = "${var.cluster_name}-asg-example"
  port = var.server_port
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default.id
  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

# 오토스케일링 그룹에서 사용할 EC2 인스턴스 런치 구성 생성
resource "aws_launch_configuration" "example" {
  image_id = "ami-0f3a440bbcff3d043"
  instance_type = var.instance_type
  security_groups = [aws_security_group.instance.id]
  user_data = templatefile("${path.module}/user-data.sh", {
    server_port = var.server_port
    db_address = data.terraform_remote_state.db.outputs.address
    db_port = data.terraform_remote_state.db.outputs.port
#    db_address  = var.db_address
#    db_port     = var.db_port
  })
  # 새로운 리소스 생성 후 기존 리소스 삭제
  lifecycle {
    create_before_destroy = true
  }
}

# 오토스케일링 그룹 생성
resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier = data.aws_subnets.default.ids
  target_group_arns = [aws_lb_target_group.asg.arn]
  min_size = var.min_size
  max_size = var.max_size
  tag {
    key = "Name"
    value = "terraform-asg-example"
    propagate_at_launch = true
  }
}

# EC2 인스턴스를 위한 보안 그룹 생성
resource "aws_security_group" "instance" {
  name = "${var.cluster_name}-instance"

  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
