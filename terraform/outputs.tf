output "Dynamo-Table" {
  value = aws_dynamodb_table.BaR.name
}

output "DDB_ARN" {
  value = aws_dynamodb_table.BaR.arn
}

output "Policy_ARN" {
  value = aws_iam_policy.UseDDB.arn
}

output "APIGW-Endpoint" {
  value = aws_apigatewayv2_api.apigw.api_endpoint
}
