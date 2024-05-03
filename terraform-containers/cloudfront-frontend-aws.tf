resource "aws_cloudfront_distribution" "nexusnet" {
  enabled  = true
  price_class = "PriceClass_All"
  depends_on = [ aws_api_gateway_deployment.postmanager, aws_api_gateway_deployment.usermanager ]

  origin {
    domain_name = "${aws_s3_bucket.frontend.website_endpoint}"
    origin_id   = "s3-${aws_s3_bucket.frontend.id}"

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = "s3-${aws_s3_bucket.frontend.id}"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
      headers = ["Host"]
    }
  }

  origin {
    domain_name = "${aws_api_gateway_stage.usermanager.invoke_url}"
    origin_id   = "api-gateway-usermanager"

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_protocol_policy   = "https-only"
      origin_ssl_protocols     = ["TLSv1.2"]
    }
  }

  origin {
    domain_name = "${aws_api_gateway_stage.postmanager.invoke_url}"
    origin_id   = "api-gateway-postmanager"

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_protocol_policy   = "https-only"
      origin_ssl_protocols     = ["TLSv1.2"]
    }
  }

  ordered_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS", "POST", "PUT", "DELETE", "PATCH"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]
    path_pattern = "usermanager*"
    target_origin_id = "api-gateway-usermanager"
    viewer_protocol_policy = "https-only"
  }

  ordered_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS", "POST", "PUT", "DELETE", "PATCH"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]
    path_pattern = "postmanager*"
    target_origin_id = "api-gateway-postmanager"
    viewer_protocol_policy = "https-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  is_ipv6_enabled = true
}