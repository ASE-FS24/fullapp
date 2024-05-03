output "cloudfront_url" {
  value = aws_cloudfront_distribution.nexusnet.domain_name
}

output "usermanager_endpoint_url" {
    description = "usermanager api end point url:"
     value = "${aws_api_gateway_stage.usermanager.invoke_url}/"
}

output "postmanager_endpoint_url" {
    description = "Postmanager api end point url:"
     value = "${aws_api_gateway_stage.postmanager.invoke_url}/"
}

output "frontend_url" {
  value = "http://${aws_s3_bucket.frontend.bucket}.s3-website-${var.aws_region}.amazonaws.com/"
}