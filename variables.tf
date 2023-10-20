variable "name" {
  type        = string
  description = "Unique name (no spaces)"
}

variable "tags" {
  type        = map(string)
  description = "AWS Tags"
  default     = {}
}