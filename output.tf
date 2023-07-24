output "bucket" {
  description = "Bucket"
  value       = aws_s3_bucket.create_bucket
}

output "bucket_name" {
  description = "Bucket name"
  value       = aws_s3_bucket.create_bucket.bucket
}

output "bucket_arn" {
  description = "Bucket ARN"
  value       = aws_s3_bucket.create_bucket.arn
}
###
output "bucket_versioning" {
  description = "Bucket versioning"
  value       = aws_s3_bucket_versioning.create_bucket_versioning
}

output "bucket_policy" {
  description = "Bucket policy"
  value       = try(aws_s3_bucket_policy.create_bucket_policy, null)
}

output "ownership_controls" {
  description = "Ownership controls"
  value       = aws_s3_bucket_ownership_controls.create_ownership_controls
}

output "access_block" {
  description = "Access block"
  value       = aws_s3_bucket_public_access_block.create_public_access_block
}

output "bucket_acl" {
  description = "Bucket ACL"
  value       = try(aws_s3_bucket_acl.create_bucket_acl, null)
}

output "cors_configuration" {
  description = "Cors configuration"
  value       = aws_s3_bucket_cors_configuration.create_bucket_cors_configuration
}

output "website_configuration" {
  description = "Website configuration"
  value       = try(aws_s3_bucket_website_configuration.create_bucket_website_configuration, null)
}

output "lifecycle_configuration" {
  description = "Lifecycle configuration"
  value       = try(aws_s3_bucket_lifecycle_configuration.create_bucket_lifecycle_configuration, null)
}
