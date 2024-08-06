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

variable "prod_cluster_name" {
  type = string
}

variable "prod_busniess_scheduled_action_name" {
  type = string
}
variable "prod_as_min_size" {
  type = number
}
variable "prod_as_max_size" {
  type = number
}
variable "prod_as_desired_capacity" {
  type = number
}
variable "prod_night_scheduled_action_name" {
  type = string
}
variable "prod_instance_size" {
  type =string
}