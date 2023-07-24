variable "bucket_name" {
  description = "Bucket name"
  type        = string
}

variable "acl_type" {
  description = "ACL to bucket > available options: private public-read public-read-write authenticated-read aws-exec-read log-delivery-write"
  type        = string
  default     = null
}

variable "object_ownership" {
  description = "Object ownership can be BucketOwnerPreferred or ObjectWriter"
  type        = string
  default     = "BucketOwnerPreferred"
}

variable "bucket_access_types" {
  description = "Manages S3 bucket-level Public Access Block configuration"
  type = object({
    block_public_acls       = optional(bool, false)
    block_public_policy     = optional(bool, false)
    ignore_public_acls      = optional(bool, false)
    restrict_public_buckets = optional(bool, false)
  })
  default = {
    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false
  }
}

variable "policy" {
  description = "Policy to bucket"
  type        = any
  default     = null
}

variable "versioning" {
  description = "Versioning status > available options: Enabled, Suspended, or Disabled"
  type        = string
  default     = "Disabled"
}

variable "force_destroy" {
  description = "Enable or Disable force destroy files when bucket is destroed"
  type        = bool
  default     = false
}

variable "ou_name" {
  description = "Organization unit name"
  type        = string
  default     = "no"
}

variable "tags" {
  description = "Tags to bucket"
  type        = map(any)
  default     = {}
}

variable "static_site" {
  description = "Define the configuration static site"
  type = object({
    key                     = string
    suffix                  = string
    key_prefix_equals       = string
    replace_key_prefix_with = string
  })
  default = null
}

variable "cors_rules" {
  description = "Define the cors rules to buckes"
  type = list(object({
    allowed_methods = list(string)
    allowed_origins = list(string)
    allowed_headers = optional(list(string))
    expose_headers  = optional(list(string))
    max_age_seconds = optional(number, null) # opcional setar um número, senão por default será null
  }))
  default = null
}

variable "bucket_lifecycles" {
  description = "Define the configurations lifecicles to bucket"
  type = list(object({
    id_name         = string
    status          = string
    filter          = optional(string)
    data_expiration = optional(number)
    versions_transitions = list(object({
      after_days = number
      move_to    = string
    }))
  }))
  default = null
}
