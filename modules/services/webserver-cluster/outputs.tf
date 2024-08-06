# ALB DNS 이름, 오토스케일링 그룹 이름, ALB 보안 그룹 ID 출력
output "alb_dns_name" {
  value = aws_lb.example.dns_name
  description = "The domain name of the load balancer"
}

output "asg_name" {
  value = aws_autoscaling_group.example.name
  description = "The name of Autoscaling Group"
}

output "alb_security_group_id" {
  value = aws_security_group.alb.id
  description = "The ID of the Security Group attached to the load balancer"
}