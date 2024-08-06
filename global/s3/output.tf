# s3 버킷의 ARN과 DynamoDB 테이블 이름 출력
output "s3_bucket_arn" {
  value = aws_s3_bucket.terraform-state.arn
  description = "The ARN of the S3 bucket"
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
  description = "The name of the DynamoDB table"
}

