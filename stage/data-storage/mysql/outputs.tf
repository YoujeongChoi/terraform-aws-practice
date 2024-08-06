/*
output 변수
테라폼 실행 후 특정 값 출력하도록 서정
배포된 인프라에 대한 중요한 정보를 사용자에게 제공하도록 사용
*/

output "address" {
  value = aws_db_instance.example.address
  description = "Connect to the database at this endpoint"
}

output "port" {
  value = aws_db_instance.example.port
  description = "The port the database is listening on"
}