resource "aws_apigatewayv2_api" "bargw" {
  name          = "BaR_gw"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "prod_stage" {
  api_id      = aws_apigatewayv2_api.bargw.id
  name        = "prodStage"
  auto_deploy = true
}

resource "aws_apigatewayv2_route" "BaR_post" {
  api_id    = aws_apigatewayv2_api.bargw.id
  route_key = "POST /post"
  target    = "integrations/${aws_apigatewayv2_integration.BaR_integr.id}"
}

resource "aws_apigatewayv2_integration" "BaR_integr" {
  api_id                 = aws_apigatewayv2_api.bargw.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.BaR.invoke_arn
  payload_format_version = "2.0"
}


resource "aws_apigatewayv2_route" "BaR_get" {
  api_id = aws_apigatewayv2_api.bargw.id
  route_key = "GET /get/{id}"
  target = "integrations/${aws_apigatewayv2_integration.BaR_integr.id}"
  
}
