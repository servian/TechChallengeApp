variable "app_command" {
  description = "Command to be executed in the running container"
  type = list(string)
  default   = [ "serve" ] //Use [ "updatedb", "-s" ] for database migrations
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  type = string
  default   =  "tech5678910/test:latest"
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 1
}