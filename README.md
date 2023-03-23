# AWS bucket for multiples accounts and regions Terraform module
* This module simplifies creating and configuring buckets across multiple accounts and regions on AWS

* Is possible use this module with one region using the standard profile or multi account and regions using multiple profiles setting in the modules.

## Actions necessary to use this module:

* Create file versions.tf with the exemple code below:
```hcl
terraform {
  required_version = ">= 1.1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.9"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.0"
    }
  }
}
```

* Criate file provider.tf with the exemple code below:
```hcl
provider "aws" {
  alias   = "alias_profile_a"
  region  = "us-east-1"
  profile = "my-profile"
}

provider "aws" {
  alias   = "alias_profile_b"
  region  = "us-east-2"
  profile = "my-profile"
}
```


## Features enable of S3 bucket configurations for this module:

- Static web site
- Versioning
- CORS
- Policy
- ACL
- Lifecycle configuration

## Usage exemples


### Private bucket with versioning enabled for one region

```hcl
module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "my-s3-bucket"
  acl    = "private"

  versioning = {
    enabled = true
  }
}
```

### Complete exemple with private bucket, versioning enabled, policy, ACL, cors for one region and without lifecycle

```hcl
module "bucket_static_site_test" {
  source      = "terraform-aws-modules/s3-bucket/aws"
  bucket_name = "tf-static-site-test"
  acl_type    = "public-read"
  versioning  = "Enabled"
  ou_name     = var.ous.sso
  cors_rules  = var.cors_rules
  policy      = local.policy_test
  static_site = var.static_site

  tags = {
    "tf-project" = "organizations"
  }

  providers = {
    aws = aws.alias_profile_b
  }
}
```

### Complete exemple with lifecycle policy, private bucket, versioning enabled, policy, ACL, cors for one region and without policy

```hcl
module "bucket_lifecycle_test" {
  source      = "terraform-aws-modules/s3-bucket/aws"
  bucket_name = "tf-lifecycle-test"
  acl_type    = "private"
  versioning  = "Enabled"
  ou_name     = var.ous.sso
  cors_rules  = var.cors_rules
  bucket_lifecycles = var.bucket_lifecycles2

  providers = {
    aws = aws.luby_sso
  }
}
```

## Variables

| Name | Type | Default | Required | Description | Options |
|------|-------------|------|---------|:--------:|:--------|
| bucket_name | `string` | `-` | yes | Name to bucket s3 | `-` |
| acl_type | `string` | `null` | no | Type of ACL | `*`private<br> `*`public-read<br> `*`public-read-write<br>  `*`authenticated-read<br> `*`aws-exec-read<br> `*`log-delivery-write |
| policy | `string` | `null` | no | Policy of ACL | `-` |
| versioning | `string` | `Disabled` | no | Versioning to bucket | `*`Enabled<br> `*`Suspended<br> `*`Disabled |
| force_destroy | `bool` | `false` | no | Force destroy bucket | `*`false <br> `*`true |
| ou_name | `string` | `no` | no | Policy of ACL | `-` |
| tags | `map(any)` | `{}` | no | Tags to bucket | `-` |
| static_site | `type = map(any)` | `null` | no | Static web site configuration | `-` |
| cors_rules | `list` | `null` | no | Cors rules to bucket | `-` |
| bucket_lifecycles | `type = map(any)` | `null` | no | Bucket lifecycle configuration | `-` |

* Model of variable static_site
```hcl
variable "static_site" {
  description = "Define configuration bucket to static site"
  type = object({
    key                     = string
    suffix                  = string
    key_prefix_equals       = string
    replace_key_prefix_with = string
  })
  default = {
    key                     = "index.html"
    suffix                  = "index.html"
    key_prefix_equals       = "/"
    replace_key_prefix_with = "/"
  }
}
```

* Model of variable cors_rules
```hcl
variable "cors_rules" {
  description = "Define the cors rules to buckes"
  type = list(object({
    allowed_methods = list(string)
    allowed_origins = list(string)
    allowed_headers = optional(list(string))
    expose_headers  = optional(list(string))
    max_age_seconds = optional(number, null) # opcional setar um número, senão por default será null
  }))
  default = [
    {
      allowed_headers = ["*"]
      allowed_methods = ["PUT", "POST"]
      allowed_origins = ["https://s3-website-test.hashicorp.com"]
      expose_headers  = ["ETag"]
      max_age_seconds = 3000
    },
    {
      allowed_methods = ["GET"]
      allowed_origins = ["*"]
    }
  ]
}
```

* Model of variable bucket_lifecycles
```hcl
variable "bucket_lifecycles" {
  description = "Define the configurations lifecicles to bucket"
  type = list(object({
    id_name = string
    status = string
    filter = optional(string)
    data_expiration = optional(number)
    versions_transitions = list(object({
      after_days = number
      move_to    = string
    }))
  }))
  default = [
    {
      id_name         = "tf-test-lifecycle"
      status          = "Enabled"
      data_expiration = 90
      filter          = "data/"
      versions_transitions = [
        {
          after_days = 30
          move_to    = "STANDARD_IA"
        },
        {
          after_days = 60
          move_to    = "GLACIER"
        }
      ]
    },
    {
      id_name = "tf-test-lifecycle2"
      status  = "Enabled"
      versions_transitions = [
        {
          after_days = 40
          move_to    = "STANDARD_IA"
        },
        {
          after_days = 70
          move_to    = "INTELLIGENT_TIERING"
        }
      ]
    }
  ]
}
```

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.create_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_versioning.create_bucket_versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_policy.create_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_acl.create_bucket_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_cors_configuration.create_bucket_cors_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration) | resource |
| [aws_s3_bucket_website_configuration.create_bucket_website_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_s3_bucket_lifecycle_configuration.create_bucket_lifecycle_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |

## Outputs

| Name | Description |
|------|-------------|
| `bucket` | All informations of the bucket |
| `bucket_arn` | The ARN of the bucket |
| `bucket_name` | The name of the bucket |
