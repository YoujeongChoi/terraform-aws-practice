terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket = var.db_remote_state_bucket
    key = var.db_remote_state_key
    region = "ap-northeast-2"
    # Replace this with your DynamoDB table name!
    dynamodb_table = var.dynamodb_table
    encrypt = true
  }
}