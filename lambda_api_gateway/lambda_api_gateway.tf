
variable "method" {default = "GET"}
variable "api_route_path" {description = "the path component for the url. Must start with /"}
variable "api_gateway_id" {}
variable "api_gateway_execution_arn" {}
variable "lambda_arn" {}
variable "lambda_invoke_arn" {}

resource "aws_apigatewayv2_integration" "lambda_integration" {
    api_id           = var.api_gateway_id
    integration_type = "AWS_PROXY"
    integration_method   = "POST"
    integration_uri      = var.lambda_invoke_arn
    passthrough_behavior = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_route" "lambda_route" {
    api_id             = var.api_gateway_id
    route_key          = "${var.method} ${var.api_route_path}"
    target             = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_lambda_permission" "api-gw-AllowExecutionFromAPIGateway" {
    statement_id  = "AllowExecutionFromAPIGateway"
    action        = "lambda:InvokeFunction"
    function_name = var.lambda_arn
    principal     = "apigateway.amazonaws.com"

    source_arn = "${var.api_gateway_execution_arn}/*/*/*"
}
