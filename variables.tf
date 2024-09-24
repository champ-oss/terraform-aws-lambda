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

variable "enable_api_gateway_v1" {
  description = "Create resource, method, and integration with API Gateway v1"
  type        = bool
  default     = false
}

variable "api_gateway_v1_rest_api_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource#rest_api_id"
  type        = string
  default     = null
}

variable "api_gateway_v1_parent_resource_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource#parent_id"
  type        = string
  default     = null
}

variable "api_gateway_v1_path_part" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource#path_part"
  type        = string
  default     = null
}

variable "api_gateway_v1_http_method" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method#http_method"
  type        = string
  default     = "ANY"
}

variable "create_api_gateway_v1_resource" {
  description = "Create a API Gateway base resource. If disabled, an existing resource ID must be provided."
  type        = bool
  default     = true
}

variable "api_gateway_v1_resource_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method#resource_id"
  type        = string
  default     = null
}

variable "api_gateway_v1_resource_path" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource#path"
  type        = string
  default     = null
}

variable "api_gateway_v1_api_key_required" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_api_key"
  type        = bool
  default     = false
}

variable "enable_custom_iam_policy" {
  description = "Attach a custom IAM policy to the Lambda IAM role"
  type        = bool
  default     = false
}

variable "custom_iam_policy_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment#policy_arn"
  type        = string
  default     = null
}

variable "alert_slack_url" {
  description = "Slack URL to use for alerts"
  type        = string
  default     = "https://hooks.slack.com/services/abc123"
}

variable "alert_region" {
  description = "AWS region for alerting"
  type        = string
  default     = "us-east-2"
}

variable "alert_filter_pattern" {
  description = "https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/FilterAndPatternSyntax.html#extract-log-event-values"
  type        = string
  default     = "ERROR"
}

variable "enable_logging_alerts" {
  description = "Enable alerts for log messages"
  type        = bool
  default     = false
}

variable "enable_iam_role_name_prefix" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role#name_prefix"
  type        = bool
  default     = true
}

variable "enable_org_access" {
  description = "Allow all accounts in current org to invoke function"
  type        = bool
  default     = false
}

variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  type        = bool
  default     = true
}

variable "enable_event_bridge_schedule" {
  description = "Enable EventBridge schedule"
  type        = bool
  default     = false
}

variable "event_bridge_schedule_expression" {
  description = "https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-schedule-expressions.html"
  type        = string
  default     = "rate(5 minutes)"
}

variable "schedule_expression_timezone" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule#schedule_expression_timezone"
  type        = string
  default     = "UTC"
}
