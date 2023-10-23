resource "aws_dynamodb_table" "BaR" {
  name = "BurnAfterRead"
  hash_key = "id"
  read_capacity = 1
  write_capacity = 1

  attribute {
    name = "id"
    type = "S"
  }
}
