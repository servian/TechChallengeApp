variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default = "terraform"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}