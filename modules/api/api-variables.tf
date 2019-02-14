variable "name" {
  description = "The name of the REST API"
}

variable "stage_name" {
  description = "The stage name for the API deployment (production/staging/etc..)"
}

variable "method" {
  description = "The HTTP method"
}

variable "lambda" {
  description = "The lambda name to invoke"
}

variable "lambda_arn" {
  description = "The lambda arn to invoke"
}

variable "lambda_invoke_arn" {
  description = "This lambda invoke"
}

variable "lambda_version" {
  description = "Lambda version"
}

variable "region" {
  description = "The AWS region, e.g., eu-west-1"
}

# variable "account_id" {
#   description = "The AWS account ID"
# }

variable "resource_name" {
  description = "This resource name api dev/resource/ "
}

variable "depends_on" {
  description = "Helper variable to simulate depends_on for terraform modules"
  default     = []
}