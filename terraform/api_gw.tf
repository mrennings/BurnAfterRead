resource "aws_apigatewayv2_api" "apigw" {
  name = "BurnAfterRead-ApiGW"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "prod_stage" {
  api_id = aws_apigatewayv2_api.apigw.id
  name = "prod"
  auto_deploy = true
}

resource "aws_apigatewayv2_route" "BaR_post" {
  api_id = aws_apigatewayv2_api.apigw.id
  route_key = "POST /"
  target = "integrations/${aws_apigatewayv2_integration.BaR_integr.id}"
} 

resource "aws_apigatewayv2_integration" "BaR_integr" {
  api_id = aws_apigatewayv2_api.apigw.id
  integration_type = "AWS_PROXY"
  integration_method = "POST"
  integration_uri = aws_lambda_function.BaR.invoke_arn
  payload_format_version = "2.0"
}


# resource "aws_apigatewayv2_route" "BaR_get" {
#   api_id = aws_apigatewayv2_api.apigw.id
#   route_key = "GET /get"
#   target = "integrations/${aws_apigatewayv2_integration.BaR_integr.id}"
# }
