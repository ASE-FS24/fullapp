resource "aws_lambda_function" "usermanager_api" {
  depends_on    = [aws_s3_bucket.usermanager]
  function_name = "${var.usermanager_name}-api"
  environment {
    variables = {
      AMAZON_ACCESS_KEY        = "${var.aws_access_key}"
      AMAZON_S3_ACCESS_KEY     = "${var.aws_access_key}"
      AMAZON_S3_SECRET_KEY     = "${var.aws_secret_key}"
      AMAZON_SECRET_KEY        = "${var.aws_secret_key}"
      AMAZON_DYNAMODB_ENDPOINT = "https://dynamodb.${var.aws_region}.amazonaws.com"
      AMAZON_S3_ENDPOINT       = "https://${var.project_name}-${var.usermanager_name}.s3.${var.aws_region}.amazonaws.com/0.0.1/"
      AMAZON_USM_BUCKET        = "nexus-net-${var.usermanager_name}"
    }
  }

  s3_bucket   = aws_s3_bucket.usermanager.bucket
  s3_key      = "${var.deployment_number}/${var.usermanager_jar}"
  handler     = var.um_lambda_function_handler
  timeout     = 60
  memory_size = 256
  runtime     = var.lambda_runtime

  role    = aws_iam_role.lambda_rest_api.arn
  publish = true
}

# resource "aws_lambda_permission" "usermanager_cloudfront" {
#   depends_on = [ aws_cloudfront_distribution.usermanager-distribution ]
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.usermanager_api.function_name
#   principal     = "cloudfront.amazonaws.com"
#   source_arn    = aws_cloudfront_distribution.usermanager-distribution.arn
# }

data "aws_iam_policy" "AWSLambdaBasicExecutionRole" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRole_to_lambda_rest_api" {
  policy_arn = data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn
  role       = aws_iam_role.lambda_rest_api.name
}
