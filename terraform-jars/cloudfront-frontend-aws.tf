resource "aws_cloudfront_cache_policy" "api_gateway_optimized" {
  name = "ApiGatewayOptimized2"

  default_ttl = 0
  max_ttl     = 0
  min_ttl     = 0

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }

    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "none"
    }
  }
}

resource "aws_cloudfront_origin_request_policy" "api_gateway_optimized" {
  name = "ApiGatewayOptimized2"

  cookies_config {
    cookie_behavior = "none"
  }

  headers_config {
    header_behavior = "whitelist"
    headers {
      items = ["Accept-Charset", "Accept", "User-Agent", "Referer"]
    }
  }

  query_strings_config {
    query_string_behavior = "all"
  }
}

resource "aws_cloudfront_distribution" "nexusnet" {
  enabled     = true
  price_class = "PriceClass_All"

  origin {
    domain_name = "${aws_s3_bucket.frontend.id}.s3-website-${aws_s3_bucket.frontend.region}.amazonaws.com"
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
        forward = "all"
      }
      headers = ["Access-Control-Request-Headers", "Access-Control-Request-Method", "Origin"]
    }
  }


  origin {
    domain_name = replace(
      replace(
        aws_api_gateway_stage.usermanager.invoke_url,
        "https://",
        ""
      ),
      "/",
      ""
    )
    origin_id = "api-gateway-usermanager"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }


  ordered_cache_behavior {
    allowed_methods          = ["GET", "HEAD", "OPTIONS", "POST", "PUT", "DELETE", "PATCH"]
    cached_methods           = ["GET", "HEAD", "OPTIONS"]
    path_pattern             = "/um-${var.api_stage_name}/*"
    target_origin_id         = "api-gateway-usermanager"
    viewer_protocol_policy   = "https-only"
    cache_policy_id          = aws_cloudfront_cache_policy.api_gateway_optimized.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.api_gateway_optimized.id
  }

  origin {
    domain_name = replace(
      replace(
        aws_api_gateway_stage.postmanager.invoke_url,
        "https://",
        ""
      ),
      "/",
      ""
    )
    origin_id = "api-gateway-postmanager"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }


  ordered_cache_behavior {
    allowed_methods          = ["GET", "HEAD", "OPTIONS", "POST", "PUT", "DELETE", "PATCH"]
    cached_methods           = ["GET", "HEAD", "OPTIONS"]
    path_pattern             = "/pm-${var.api_stage_name}/*"
    target_origin_id         = "api-gateway-postmanager"
    viewer_protocol_policy   = "https-only"
    cache_policy_id          = aws_cloudfront_cache_policy.api_gateway_optimized.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.api_gateway_optimized.id
  }

  origin {
    domain_name = replace(
      replace(
        aws_api_gateway_stage.chatmanager.invoke_url,
        "https://",
        ""
      ),
      "/",
      ""
    )
    origin_id = "api-gateway-chatmanager"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }


  ordered_cache_behavior {
    allowed_methods          = ["GET", "HEAD", "OPTIONS", "POST", "PUT", "DELETE", "PATCH"]
    cached_methods           = ["GET", "HEAD", "OPTIONS"]
    path_pattern             = "/cm-${var.api_stage_name}/*"
    target_origin_id         = "api-gateway-chatmanager"
    viewer_protocol_policy   = "https-only"
    cache_policy_id          = aws_cloudfront_cache_policy.api_gateway_optimized.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.api_gateway_optimized.id
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["AD", "AL", "AM", "AT", "AZ", "BA", "BE", "BG", "BY", "CH", "CY", "CZ", "DE", "DK", "EE", "ES", "FI", "FO", "FR", "GB", "GE", "GG", "GI", "GR", "HR", "HU", "IE", "IM", "IS", "IT", "JE", "LI", "LT", "LU", "LV", "MC", "MD", "ME", "MK", "MT", "NL", "NO", "PL", "PT", "RO", "RS", "RU", "SE", "SI", "SJ", "SK", "SM", "UA", "VA"]
      # Restrict access to users from Europe
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  is_ipv6_enabled = true
}
