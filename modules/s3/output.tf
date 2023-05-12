output "s3_domain_name" {
  value = aws_s3_bucket_website_configuration.s3_bucket.website_domain
}

output "website_address" {
  value = var.domain_name
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.s3_bucket.arn
}

output "s3_bucket_name" {
  value = aws_s3_bucket.s3_bucket.id
}