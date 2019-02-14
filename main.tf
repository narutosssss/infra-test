
data "aws_iam_role" "role" {
    name = "MyRole"
}

resource "null_resource" "git_pull" {
  # provisioner "local-exec" {
  #   command = "git clone https://github.com/ifew/aws-lambda-proxy-function.git project_workspace"
  # } 
  # provisioner "local-exec" {
  #   command = "cd project_workspace/test/aws-lambda-function.Tests && dotnet test"
  #   interpreter = ["/bin/sh", "-c"]
  # } 

  # provisioner "local-exec" {
  #   command           = "cd project_workspace/src/aws-lambda-function && dotnet publish -c Release"
  #   interpreter       = ["/bin/sh", "-c"]
  # }
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
  role_name               = "${data.aws_iam_role.role.arn}"
  publish_version         = false
  #api
  api_name                = "my_api_name"
  resource_name           = "test"
  http_method             = "GET"
  stage_name              = "dev"
}

