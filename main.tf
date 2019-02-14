
resource "aws_iam_role" "first_lambda_role" {
  name = "first_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
      tag-key = "tag-value"
  }
}


#deploy lambda & rest api
module "list_profile" {
  depends_on              = ["null_resource.git_pull"]
  source                  = "modules/lambda"
  name                    = "terraform-workshop"
  handler                 = "aws-lambda-function::aws_lambda_function.Function::FunctionHandler"
  runtime                 = "${module.global_variables.runtime}"
  source_dir              = "project_workspace/src/aws-lambda-function/bin/Release/netcoreapp2.1/publish"
  output_path             = "project_workspace/deployment.zip"
  role_name               = "${aws_iam_role.first_lambda_role.arn}"
  publish_version         = true
  #api
  api_name                = "my_api_name"
  resource_name           = "test"
  http_method             = "GET"
  stage_name              = "dev"
}

