variable "aws_region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "image_uri" {
  type = string
}

variable "execution_role_arn" {
  type = string
}