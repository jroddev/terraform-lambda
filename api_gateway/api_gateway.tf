resource "aws_apigatewayv2_api" "lambda_api" {
    name          = "lambda-gateway"
    protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "lambda_stage" {
    api_id      = aws_apigatewayv2_api.lambda_api.id
    name        = "$default"
    auto_deploy = true
}

output "id" {
  value = aws_apigatewayv2_api.lambda_api.id
}

output "execution_arn" {
  value = aws_apigatewayv2_api.lambda_api.execution_arn
}


