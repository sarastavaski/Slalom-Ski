resource "aws_cloudfront_distribution" "s3_distribution" {
  origin_group {
    origin_id = "groupS3"

    failover_criteria {
      status_codes = [403, 404, 500, 502]
    }

    member {
      origin_id = "primaryS3"
    }

    member {
      origin_id = "failoverS3"
    }
  }

  origin {
    domain_name = var.primary-bucket-regional-domain-name
    origin_id   = "primaryS3"

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/EKS9QQTXUTLKE"
      #origin_access_identity = aws_cloudfront_origin_access_identity.default.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = var.failover-bucket-regional-domain-name
    origin_id   = "failoverS3"

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/E3J5HBQJ8OQJGW"
      #origin_access_identity = aws_cloudfront_origin_access_identity.default.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"


  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]

    cached_methods = [
      "GET",
      "HEAD",
    ]

    target_origin_id = "groupS3"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"

    # https://stackoverflow.com/questions/67845341/cloudfront-s3-etag-possible-for-cloudfront-to-send-updated-s3-object-before-t
    min_ttl     = var.cloudfront_min_ttl
    default_ttl = var.cloudfront_default_ttl
    max_ttl     = var.cloudfront_max_ttl
  }

  price_class = var.price_class

  restrictions {
    geo_restriction {
      restriction_type = var.cloudfront_geo_restriction_restriction_type
      locations = []
    }
  }
  
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    error_caching_min_ttl = 0
    response_page_path    = "/index.html"
  }

  wait_for_deployment = false
  tags                = var.tags
}
