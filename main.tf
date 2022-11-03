resource "aws_s3_bucket" "create_bucket" {
  provider      = aws
  bucket        = var.bucket_name
  force_destroy = var.force_destroy

  tags = merge(var.tags, {
    "tf-type"   = "bucket"
    "tf-bucket" = var.bucket_name
    "tf-ou"     = var.ou_name
  })
}

resource "aws_s3_bucket_versioning" "create_bucket_versioning" {
  bucket = aws_s3_bucket.create_bucket.id

  versioning_configuration {
    status = var.versioning
  }
}

resource "aws_s3_bucket_policy" "create_bucket_policy" {
  count  = var.policy != null ? 1 : 0
  bucket = aws_s3_bucket.create_bucket.id
  policy = var.policy
}

resource "aws_s3_bucket_acl" "create_bucket_acl" {
  count  = var.acl_type != null ? 1 : 0
  bucket = aws_s3_bucket.create_bucket.bucket
  acl    = var.acl_type
}

resource "aws_s3_bucket_cors_configuration" "create_bucket_cors_configuration" {
  count  = var.cors_rules != null ? 1 : 0
  bucket = aws_s3_bucket.create_bucket.id

  dynamic "cors_rule" {
    for_each = var.cors_rules
    content {
      id              = try(cors_rule.value.id, null)
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      allowed_headers = try(cors_rule.value.allowed_headers, null)
      expose_headers  = try(cors_rule.value.expose_headers, null)
      max_age_seconds = try(cors_rule.value.max_age_seconds, null)
    }
  }
}

resource "aws_s3_bucket_website_configuration" "create_bucket_website_configuration" {
  count  = (var.cors_rules != null && var.static_site != null) ? 1 : 0
  bucket = aws_s3_bucket.create_bucket.id

  index_document {
    suffix = var.static_site.suffix
  }

  error_document {
    key = var.static_site.key
  }

  routing_rule {
    condition {
      key_prefix_equals               = try(var.static_site.key_prefix_equals, null)
      http_error_code_returned_equals = try(var.static_site.http_error_code_returned_equals, null)
    }

    redirect {
      replace_key_prefix_with = try(var.static_site.replace_key_prefix_with, null)
      host_name               = try(var.static_site.host_name, null)
      http_redirect_code      = try(var.static_site.http_redirect_code, null)
      protocol                = try(var.static_site.protocol, null)
      replace_key_with        = try(var.static_site.replace_key_with, null)
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "create_bucket_lifecycle_configuration" {
  count  = var.bucket_lifecycles != null ? 1 : 0
  bucket = aws_s3_bucket.create_bucket.id

  dynamic "rule" {
    for_each = var.bucket_lifecycles
    content {
      id     = rule.value.id_name
      status = rule.value.status

      dynamic "noncurrent_version_transition" {
        for_each = rule.value.versions_transitions
        content {
          noncurrent_days = noncurrent_version_transition.value.after_days
          storage_class   = noncurrent_version_transition.value.move_to
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = try(rule.value.data_expiration, []) != null ? [1] : []
        content {
          noncurrent_days = rule.value.data_expiration
        }
      }

      dynamic "filter" {
        for_each = try(rule.value.filter, []) != null ? [1] : []
        content {
          prefix = rule.value.filter
        }
      }
    }
  }

  depends_on = [aws_s3_bucket_versioning.create_bucket_versioning]
}
