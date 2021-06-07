variable "function_name" {}
variable "function_directory" {}
variable "function_handler" {}
variable "function_runtime" {}
variable "iam_role" {}


data "archive_file" "lambda_zip" {
    type        = "zip"
    source_dir  = var.function_directory
    output_path = "${var.function_directory}/lambda.zip"
}

resource "aws_lambda_function" "lambda" {
    filename      = data.archive_file.lambda_zip.output_path
    function_name = var.function_name
    role          = var.iam_role
    handler       = var.function_handler

    source_code_hash = data.archive_file.lambda_zip.output_base64sha256
    runtime = var.function_runtime
}

resource "aws_cloudwatch_log_group" "lambda_function" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 14
}

output "arn" {
  value = aws_lambda_function.lambda.arn
}

output "invoke_arn" {
  value = aws_lambda_function.lambda.invoke_arn
}