/*
output 변수
테라폼 코드 실행 후 특정 값 출력하도록 설정
배포된 인프라에 대한 중요한 정보를 사용자에게 제공하기 위해 설정
*/

output "alb_dns_name" {
  value = module.webserver_cluster.alb_dns_name
  description = "The domain name of the load balancer"
}

output "alb_security_group_id" {
  value = module.webserver_cluster.alb_security_group_id
  description = "The ID of the Security Group attached to the load balancer"
}

output "asg_name" {
  value = module.webserver_cluster.asg_name
  description = "The name of the Autoscaling Group"
}
