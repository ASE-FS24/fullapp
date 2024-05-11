resource "aws_lambda_function" "chatmanager_api" {
  depends_on    = [aws_s3_bucket.chatmanager]
  function_name = "${var.chatmanager_name}-api"
  environment {
    variables = {
      AMAZON_ACCESS_KEY        = "${var.aws_access_key}"
      AMAZON_S3_ACCESS_KEY     = "${var.aws_access_key}"
      AMAZON_S3_SECRET_KEY     = "${var.aws_secret_key}"
      AMAZON_SECRET_KEY        = "${var.aws_secret_key}"
      AMAZON_DYNAMODB_ENDPOINT = "https://dynamodb.${var.aws_region}.amazonaws.com"
      AMAZON_S3_ENDPOINT       = "https://${var.project_name}-${var.chatmanager_name}.s3.${var.aws_region}.amazonaws.com/0.0.1/"
      AMAZON_USM_BUCKET        = "nexus-net-${var.chatmanager_name}"
    }
  }

  s3_bucket   = aws_s3_bucket.chatmanager.bucket
  s3_key      = "${var.deployment_number}/${var.chatmanager_jar}"
  handler     = var.cm_lambda_function_handler
  timeout     = 60
  memory_size = 256
  runtime     = var.lambda_runtime

  role    = aws_iam_role.lambda_rest_api.arn
  publish = true
}

# resource "aws_lambda_permission" "chatmanager_cloudfront" {
#   depends_on = [ aws_cloudfront_distribution.chatmanager-distribution ]
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.chatmanager_api.function_name
#   principal     = "cloudfront.amazonaws.com"
#   source_arn    = aws_cloudfront_distribution.chatmanager-distribution.arn
# }
