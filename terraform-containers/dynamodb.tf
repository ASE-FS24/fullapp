resource "aws_dynamodb_table" "user_info" {
  name              = "UserInfo"  # Set the name of the DynamoDB table for user info
  billing_mode      = "PAY_PER_REQUEST"  # Set the billing mode for the table
  hash_key          = "id"  # Set the hash key attribute for the table
  attribute {
    name = "id"
    type = "S"  # Set the data type of the attribute (String in this case)
  }
  attribute {
    name = "username"
    type = "S"
  }
  global_secondary_index {
    name               = "UsernameIndex"  # Set the name of the global secondary index
    hash_key           = "username"  # Set the hash key attribute for the index
    projection_type    = "ALL"  # Set the projection type for the index
  }
}

resource "aws_dynamodb_table" "follow" {
  name              = "Follow"  # Set the name of the DynamoDB table for follow
  billing_mode      = "PAY_PER_REQUEST"  # Set the billing mode for the table
  hash_key          = "userId"  # Set the hash key attribute for the table
  attribute {
    name = "userId"
    type = "S"  # Set the data type of the attribute (String in this case)
  }
}

resource "aws_dynamodb_table" "posts" {
  name              = "Posts"
  billing_mode      = "PAY_PER_REQUEST"
  hash_key          = "id"
  attribute {
    name = "id"
    type = "S" 
  }
}


#### Policy ####
resource "aws_iam_policy" "dynamodb_default" {
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "dynamodb:PutItem",
                "dynamodb:GetItem",
                "dynamodb:Query",
                "dynamodb:GetRecords",
                "dynamodb:Scan"
            ],
            "Resource": [
                "${aws_dynamodb_table.user_info.arn}",
                "${aws_dynamodb_table.follow.arn}",
                "${aws_dynamodb_table.posts.arn}"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "dynamodb_default_to_lambda_rest_api" {
  policy_arn = aws_iam_policy.dynamodb_default.arn
  role = aws_iam_role.lambda_rest_api.name
}