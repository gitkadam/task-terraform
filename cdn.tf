resource "aws_s3_bucket" "b" {
  bucket = "mybucket27feb"

  tags = {
    Name = "My bucket"
  }
}
resource "aws_cloudfront_distribution" "my_distribution" {
  origin {
    domain_name = "mybucket27feb.s3.amazonaws.com"
    origin_id   = "CustomOrigin"
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "My CloudFront Distribution"
  
  default_cache_behavior {
    target_origin_id       = "CustomOrigin"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Add additional cache behaviors or customizations as needed

  # Viewer certificate example
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # Restrict access example
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }
}
