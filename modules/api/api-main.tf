locals {
  name              = "${var.name}"
  stage_name        = "${var.stage_name}"
  resource_name     = "${var.resource_name}"
  method            = "${var.method}"
  region            = "${var.region}"
  # account_id        = "${var.account_id}"
  lambda_arn        = "${var.lambda_arn}"
  lambda_invoke_arn = "${var.lambda_invoke_arn}"
  lambda_version    = "${var.lambda_version}"
}

# API Gateway
# API Gateway
resource "aws_api_gateway_rest_api" "api" {
  name = "${local.name}"
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "${local.stage_name}"
  depends_on  = [
      "aws_api_gateway_integration.request_method_integration",
      "aws_api_gateway_method.request_method",
      "aws_api_gateway_integration_response.response_method_integration",
      "aws_api_gateway_method_response.response_method"
      ]
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  path_part   = "${local.resource_name}"
}

resource "aws_api_gateway_method" "request_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.proxy.id}"
  http_method   = "${local.method}"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "request_method_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.proxy.id}"
  http_method = "${aws_api_gateway_method.request_method.http_method}"
  type        = "AWS_PROXY"
  uri         = "arn:aws:apigateway:${local.region}:lambda:path/2015-03-31/functions/${local.lambda_arn}:${local.lambda_version}/invocations"

  # AWS lambdas can only be invoked with the POST method
  integration_http_method = "POST"
}

# lambda => GET response
resource "aws_api_gateway_method_response" "response_method" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.proxy.id}"
  http_method = "${aws_api_gateway_integration.request_method_integration.http_method}"
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "response_method_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.proxy.id}"
  http_method = "${aws_api_gateway_method_response.response_method.http_method}"
  status_code = "${aws_api_gateway_method_response.response_method.status_code}"

  response_templates = {
    "application/json" = ""
  }
}

resource "aws_lambda_permission" "allow_api_gateway" {
  function_name = "${local.lambda_arn}"
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  # source_arn    = "arn:aws:execute-api:${local.region}:${local.account_id}:${aws_api_gateway_rest_api.api.id}/*/${local.method}${aws_api_gateway_resource.proxy.path}"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*/*"
  depends_on    = ["aws_api_gateway_rest_api.api", "aws_api_gateway_resource.proxy"]
}
