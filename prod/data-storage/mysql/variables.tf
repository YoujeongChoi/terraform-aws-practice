variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  type        = number
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  type        = number
}

variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type        = string
}

variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket for the database's remote state"
  type        = string
}

variable "db_remote_state_key" {
  description = "The path for the database's remote state in S3"
  type        = string
}

variable "server_port" {
  description = "Server port for HTTP requests"
  type        = number
  default     = 8080
}

variable "db_username" {
  description = "The username for the database"
  type        = string
}

variable "db_password" {
  description = "The password for the database"
  type        = string
}


variable "db_address" {
  description = "The address of the database"
  type        = string
}

variable "db_port" {
  description = "The port the database is listening on"
  type        = number
}
variable "db_instance_class" {
  type = string
}
variable "db_name" {
  type = string
}
variable "db_allocated_storage" {
  type = number
}
variable "db_engine" {
  type = string
}
variable "db_allocate_storage" {
  type = number
}

variable "dynamodb_table" {
  type = string
}