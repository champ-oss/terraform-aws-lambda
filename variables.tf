variable "tags" {
  description = "Map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "git" {
  description = "Name of the Git repo"
  type        = string
}

variable "name" {
  description = "Unique identifier for naming resources"
  type        = string
}

variable "enable_route53" {
  description = "Create Route 53 record"
  type        = bool
  default     = false
}

variable "enable_load_balancer" {
  description = "Attach the Lambda to a ALB"
  type        = bool
  default     = false
}

variable "enable_vpc" {
  description = "Run the lambda inside a VPC"
  type        = bool
  default     = false
}

variable "zone_id" {
  description = "https://www.terraform.io/docs/providers/aws/r/route53_record.html#zone_id"
  type        = string
  default     = ""
}

variable "memory_size" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#memory_size"
  type        = number
  default     = 128
}

variable "retention_in_days" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group#retention_in_days"
  type        = number
  default     = 365
}

variable "environment" {
  description = "Map of configuration values to be converted into ECS native format"
  type        = map(string)
  default     = {}
}

variable "reserved_concurrent_executions" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#reserved_concurrent_executions"
  type        = number
  default     = -1
}

variable "ecr_account" {
  description = "AWS account of ECR repository"
  type        = string
  default     = ""
}

variable "ecr_name" {
  description = "Name of ECR repository"
  type        = string
  default     = ""
}

variable "ecr_tag" {
  description = "Tag of ECR image"
  type        = string
  default     = ""
}

variable "sync_image" {
  description = "Sync a specific docker image tag from another location (ex: Docker Hub) to ECR"
  type        = bool
  default     = false
}

variable "sync_source_repo" {
  description = "Name of the source docker repo to sync (ex: myaccount/myrepo)"
  type        = string
  default     = ""
}

variable "filename" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#filename"
  type        = string
  default     = ""
}

variable "source_code_hash" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#source_code_hash"
  type        = string
  default     = ""
}

variable "handler" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#handler"
  type        = string
  default     = ""
}

variable "runtime" {
  description = "https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html"
  type        = string
  default     = ""
}

variable "timeout" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#timeout"
  type        = number
  default     = 30
}

variable "vpc_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#vpc_id"
  type        = string
  default     = ""
}

variable "private_subnet_ids" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster#subnet_ids"
  type        = list(string)
  default     = []
}

variable "deregistration_delay" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#deregistration_delay"
  default     = 30
  type        = number
}

variable "listener_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule#listener_arn"
  type        = string
  default     = ""
}

variable "dns_name" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record#name"
  type        = string
  default     = ""
}

variable "lb_dns_name" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#dns_name"
  type        = string
  default     = ""
}

variable "lb_zone_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#zone_id"
  type        = string
  default     = ""
}

variable "disable_wait_for_ecr" {
  description = "Do not wait for the ECR image tag to become available"
  type        = bool
  default     = false
}

variable "description" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#description"
  type        = string
  default     = ""
}

variable "enable_cw_event" {
  description = "Enable CloudWatch event to trigger the lambda"
  type        = bool
  default     = false
}

variable "schedule_expression" {
  description = "schedule expression using cron"
  type        = string
  default     = "cron(15 10 * * ? *)"
}

variable "enable_function_url" {
  description = "Create a function URL which is a dedicated HTTP(S) endpoint for your Lambda function"
  type        = bool
  default     = false
}

variable "function_url_authorization_type" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_url#authorization_type"
  type        = string
  default     = "AWS_IAM"
}

variable "image_config_command" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#command"
  type        = list(string)
  default     = null
}

variable "image_config_entry_point" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#entry_point"
  type        = list(string)
  default     = null
}

variable "image_config_working_directory" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#working_directory"
  type        = string
  default     = null
}
