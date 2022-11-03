variable "bucket_name" {
  description = "Bucket name"
  type        = string
}

variable "acl_type" {
  description = "ACL to bucket > available options: private public-read public-read-write authenticated-read aws-exec-read log-delivery-write"
  type        = string
  default     = null
}

variable "policy" {
  description = "Policy to bucket"
  type        = string
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
  type    = string
  default = "no"
}

variable "tags" {
  description = "Tags to bucket"
  type        = map(any)
  default     = {}
}

variable "static_site" {
  description = "Define the configuration static site"
  type        = map(any)
  default     = null
}

variable "cors_rules" {
  description = "Define the cors rules to buckes"
  # type = list(any)
  default = null
}

variable "bucket_lifecycles" {
  description = "Define the configurations lifecicles to bucket"
  # type = map(any)
  default = null
}
