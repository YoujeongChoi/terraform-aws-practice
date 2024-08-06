variable "server_port" {
  description = "server port for http request"
  type = number
  default = 8080
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "terraform_remote_state" "db" {
  backend = "s3"
  config = {
    bucket = "cloudwave-cj-youjeong"
    key = "stage/data-stores/mysql/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket for the database's remote state"
  type        = string
}

variable "db_remote_state_key" {
  description = "The path for the database's remote state in S3"
  type        = string
}

variable "sg_from_port" {
  type  = number
}

variable "sg_to_port" {
  type  = number
}