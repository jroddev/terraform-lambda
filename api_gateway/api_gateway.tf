resource "aws_apigatewayv2_api" "lambda_api" {
    name          = "lambda-gateway"
    protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "lambda_stage" {
    api_id      = aws_apigatewayv2_api.lambda_api.id
    name        = "$default"
    auto_deploy = true
}

# How to connect this to our API Gateway? We don't use gateway rest
resource "aws_api_gateway_rest_api_policy" "test" {
  rest_api_id = aws_api_gateway_rest_api.test.id

  policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "AWS": "*"
          },
          "Action": "execute-api:Invoke",
          "Resource": "${aws_api_gateway_rest_api.test.execution_arn}",
          "Condition": {
            "IpAddress": {
              "aws:SourceIp": "52.63.237.178/32"
            }
          }
        }
      ]
    })
}

output "id" {
  value = aws_apigatewayv2_api.lambda_api.id
}

output "execution_arn" {
  value = aws_apigatewayv2_api.lambda_api.execution_arn
}


