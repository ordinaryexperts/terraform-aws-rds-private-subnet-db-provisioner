variable "function_name" {
  type        = string
  description = "Name for the Lambda function"
}

variable "tags" {
  type        = map(string)
  description = "AWS Tags"
  default     = {}
}