output "s3_bucket_name" {
  description = "Name of the S3 bucket for media storage"
  value       = aws_s3_bucket.media.id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket for media storage"
  value       = aws_s3_bucket.media.arn
}

output "static_bucket_name" {
  description = "Name of the S3 bucket for static assets"
  value       = aws_s3_bucket.static.id
}

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.main.id
}

output "cloudfront_distribution_domain" {
  description = "Domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.main.domain_name
}

output "cloudfront_distribution_arn" {
  description = "ARN of the CloudFront distribution"
  value       = aws_cloudfront_distribution.main.arn
}