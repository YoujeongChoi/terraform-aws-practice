provider "aws" {
  region = "ap-northeast-2"
}

# 테라폼 상태 파일을 저장할 S3 버킷 생성
resource "aws_s3_bucket" "terraform-state" {
  bucket = var.bucket

  # 버킷이 실수로 삭제되지 않도록 방지
  lifecycle {
    prevent_destroy = true
  }
}

# 버전 관리를 활성화하여 상태 파일의 모든 수정 내역을 저장
resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform-state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 서버 측 암호화 설정
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform-state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.sse_algorithm
    }
  }
}

# S3 버킷에 대한 모든 공용 접근 차단
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.terraform-state.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

# 테라폼 상태 잠금을 위한 DynamoDB 테이블 생성
resource "aws_dynamodb_table" "terraform_locks" {
  name = var.dynamodb_table
  # 과금 방식
  billing_mode = var.billing_mode
  hash_key = var.hash_key
  attribute {
    name = var.hash_key
    type = "S"
  }
}

# 테라폼 백엔드를 S3로 설정하여 상태 파일 관리
terraform {
  backend "s3" {
    bucket = var.bucket
    key = var.bucket_key
    region = "ap-northeast-2"
    dynamodb_table = var.dynamodb_table
    encrypt = true
  }
}
