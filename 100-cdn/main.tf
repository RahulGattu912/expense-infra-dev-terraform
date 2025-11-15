resource "aws_cloudfront_distribution" "expense_cdn" {
  origin {
    domain_name              = "${var.project_name}-${var.environment}.${var.domain_name}"
    origin_id                = "${var.project_name}-${var.environment}.${var.domain_name}"
  }

  enabled             = true

  aliases = ["${var.project_name}-cdn.${var.domain_name}"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.project_name}-${var.environment}.${var.domain_name}"


    viewer_protocol_policy = "https-only"
    cache_policy_id = data.aws_cloudfront_cache_policy.noCache.id # we are fetching policy id from data source
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/images/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "${var.project_name}-${var.environment}.${var.domain_name}"

    viewer_protocol_policy = "https-only"
    cache_policy_id = data.aws_cloudfront_cache_policy.cacheEnable.id # we are fetching policy id from data source
    
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/static/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.project_name}-${var.environment}.${var.domain_name}"

    viewer_protocol_policy = "https-only"
    cache_policy_id = data.aws_cloudfront_cache_policy.cacheEnable.id # we are fetching policy id from data source
   
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
    #   locations        = ["US", "CA", "GB", "DE"]
        locations = ["IN"]
    }
  }

  viewer_certificate {
    acm_certificate_arn = local.https_certificate_arn
    ssl_support_method  = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

    tags = merge(
        var.common_tags,
        {
            Name = "${var.project_name}-${var.environment}-cdn"
        }
    )

}
