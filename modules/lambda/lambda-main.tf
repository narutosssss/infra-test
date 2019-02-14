module "global_variables" {
  source="../global_variables"
}

locals {
  region      = "${module.global_variables.region}"
  handler     = "${var.handler}"
  runtime     = "${var.runtime}"
  name        = "${var.name}"
  role_name   = "${var.role_name}"
  timeout     = "${var.timeout}"
  source_dir  = "${var.source_dir}"
  output_path = "${var.output_path}"
  environment = "${var.environment}"
  # api 
  api_name    = "${var.api_name}"
  resource_name   = "${var.resource_name}"
  http_method   = "${var.http_method}"
  stage_name    = "${var.stage_name}"
  publish_version = "${var.publish_version}"
}

data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${local.source_dir}"
  output_path = "${local.output_path}"
}

resource "aws_lambda_function" "lambda" {
  # filename          = "${data.archive_file.lambda.output_path}"
  # function_name     = "${var.name}"
  filename         = "${local.output_path}"
  function_name    = "${local.name}"
  role             = "${var.role_name}"
  handler          = "${local.handler}"
  runtime          = "${local.runtime}"
  source_code_hash = "${base64sha256(file("${data.archive_file.lambda.output_path}"))}"
  timeout          = "${local.timeout}"
  publish          =  "${local.publish_version}"
  # count = "${var.google_vpc_cidr != "" ? 1 : 0}"

  environment {
    variables = "${local.environment}"
  }

  tags = "${var.tags}"
}

#########
# call modules api
########
module "api" {
  depends_on        = ["aws_lambda_function.lambda"]
  source            = "../api"
  lambda            = "${aws_lambda_function.lambda.name}"
  lambda_arn        = "${aws_lambda_function.lambda.arn}"
  lambda_invoke_arn = "${aws_lambda_function.lambda.invoke_arn}"
  lambda_version    = "${aws_lambda_function.lambda.version}"
  region            = "${local.region}"
  name              = "${local.api_name}"
  resource_name     = "${local.resource_name}"
  method            = "${local.http_method}"
  stage_name        = "${local.stage_name}"
}

