variable "environment" {
  type = string
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = "${var.environment}-pokemon-web"

  force_destroy = true

  tags = {
    Environment = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "block_all_public_access" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.website_bucket.bucket_regional_domain_name
}

output "s3_bucket_id" {
  value = aws_s3_bucket.website_bucket.id
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.website_bucket.arn
}
