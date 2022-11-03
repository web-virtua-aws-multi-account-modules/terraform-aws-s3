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
