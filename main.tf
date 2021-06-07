terraform {
  backend "s3" {
    bucket  = "SET ME"
    key     = "SET ME"
    region  = "ap-southeast-2"
  }
}

variable "region" {default = "ap-southeast-2"}

provider "aws" {
  region = var.region
}

module "iam_role" {
    source          = "./iam_role"
    iam_role_name   = "terraform-lambda-iam"
}

module "api_gateway" {
    source = "./api_gateway"
}

####################### < HELLO > #################################

# Create the Hello Lambda
module "lambda__hello_lambda" {
    source              = "./lambda"
    function_name       = "hello_lambda"
    function_directory  = "scripts/hello_lambda"
    function_handler    = "hello_lambda.lambda_handler"
    function_runtime    = "python3.8"
    iam_role            = module.iam_role.arn
}

# Make Hello Lambda accessible via API
module "lambda_gateway__hello_lambda" {
    source = "./lambda_api_gateway"
    api_route_path = "/hello"
    api_gateway_id = module.api_gateway.id
    api_gateway_execution_arn = module.api_gateway.execution_arn

    lambda_arn = module.lambda__hello_lambda.arn
    lambda_invoke_arn = module.lambda__hello_lambda.invoke_arn
}

####################### </ HELLO > #################################

####################### < HELLO 2 > #################################

# Create the Hello Lambda
module "lambda__hello_lambda_2" {
    source              = "./lambda"
    function_name       = "hello_lambda_2"
    function_directory  = "scripts/hello_lambda_2"
    function_handler    = "hello_lambda.lambda_handler"
    function_runtime    = "python3.8"
    iam_role            = module.iam_role.arn
}

# Make Hello Lambda accessible via API
module "lambda_gateway__hello_lambda_2" {
    source = "./lambda_api_gateway"
    api_route_path = "/hello2"
    api_gateway_id = module.api_gateway.id
    api_gateway_execution_arn = module.api_gateway.execution_arn

    lambda_arn = module.lambda__hello_lambda_2.arn
    lambda_invoke_arn = module.lambda__hello_lambda_2.invoke_arn
}

####################### </ HELLO 2 > #################################

####################### < ec2_start_stop > #################################

# Create the Lambda
module "lambda__ec2_start_stop" {
    source              = "./lambda"
    function_name       = "ec2_start_stop"
    function_directory  = "scripts/ec2_start_stop"
    function_handler    = "ec2_start_stop.lambda_handler"
    function_runtime    = "python3.8"
    iam_role            = module.iam_role.arn
}

# Make Lambda accessible via API
module "lambda_gateway__ec2_start_stop" {
    source = "./lambda_api_gateway"
    api_route_path = "/dev-vm"
    api_gateway_id = module.api_gateway.id
    api_gateway_execution_arn = module.api_gateway.execution_arn

    lambda_arn = module.lambda__ec2_start_stop.arn
    lambda_invoke_arn = module.lambda__ec2_start_stop.invoke_arn
}

####################### </ ec2_start_stop > #################################