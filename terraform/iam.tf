resource "aws_iam_role" "BaR" {
  name = "BurnAfterRead"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
  })
}

resource "aws_iam_policy" "UseDDB" {
  name = "AllowUsingDynamoDB"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:DeleteItem",
                "dynamodb:GetItem",
                "dynamodb:PutItem",
                "dynamodb:Scan",
                "dynamodb:UpdateItem"
            ],
            # "Resource": "arn:aws:dynamodb:eu-central-1:898860150874:table/*"
            "Resource": "${aws_dynamodb_table.BaR.arn}"
        }
    ]
  })
}

resource "aws_iam_policy" "Logging" {
  name = "Allow_logging"
  path = "/"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
  })
}


resource "aws_iam_role_policy_attachment" "DDBAttach" {
  role = "${aws_iam_role.BaR.name}"
  policy_arn = "${aws_iam_policy.UseDDB.arn}"
}

resource "aws_iam_role_policy_attachment" "lmbd_log" {
  role = "${aws_iam_role.BaR.name}"
  policy_arn = "${aws_iam_policy.Logging.arn}"
}
