variable "name" {
  type        = string
  description = "Unique name (no spaces)"
  nullable    = false
}

variable "tags" {
  type        = map(string)
  description = "AWS Tags"
  nullable    = false
  default     = {}
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets where target databases live and where Lambda function will be deployed"
  nullable    = false
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security groups granting access to target databases"
  nullable    = false
}

