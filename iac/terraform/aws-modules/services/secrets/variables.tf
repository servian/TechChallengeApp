variable "name" {
  description = "the name of your app"
}

variable "application_secrets" {
  description = "A map of secrets that is passed into the application. Formatted like ENV_VAR = VALUE"
  type        = map(string)
}

