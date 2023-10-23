data "archive_file" "lmbd_func" {
  type        = "zip"
  source_file = "../burnafterread.py"
  output_path = "burnafterread.zip"
}

resource "aws_lambda_function" "BaR" {
  filename      = "burnafterread.zip"
  function_name = "burn_after_read"
  role          = aws_iam_role.BaR.arn
  runtime       = "python3.11"
  handler       = "burnafterread.burn_after_read"
  environment {
    variables = {
      TBLNAME = aws_dynamodb_table.BaR.name,
      BASEURL = "${aws_apigatewayv2_api.bargw.api_endpoint}/${aws_apigatewayv2_stage.prod_stage.name}"
    }
  }
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.BaR.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.bargw.execution_arn}/*/*/post"
}
