variable "source_dir" {
  description = "The function folder to be archived"
}

variable "output_path" {
  description = "The output of the archive file"
}

variable "name" {
  description = "A unique name for your Lambda Function"
}

variable "handler" {
  description = "handler name"
  
}

variable "role_name" {
  description = "A unique name for your Lambda Function Role"
}

variable "log_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in lambda function log group"
  default     = 30
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds"
  default     = 3
}

variable "environment" {
  description = "A map that defines environment variables for the Lambda function"

  default = {
    dummy = "_"
  }
}

variable "tags" {
  description = "Tags to associate with resources"
  default     = {}
}

# depends_on workaround

variable "depends_on" {
  description = "Helper variable to simulate depends_on for terraform modules"
  default     = []
}

variable "runtime" {
  description = "my runtime lambda"
}

variable "api_name" {
  description = "api name api"
}

variable "resource_name" {
  description = "api resource name  api/respurce"
}

variable "http_method" {
  description = "http_method api/resource/method"
}

variable "stage_name" {
  description = "stete api/resource/dev or prod"
}
variable "publish_version" {
  description = "my publish version of lambda"
  
}
