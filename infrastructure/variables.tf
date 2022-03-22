variable "tag_prefix" {
  type = string
}

variable "TF_DBUSER" {
  ## passed this value from ENV Varibles
  type = string
}

variable "TF_DBPASSWORD" {
  ## passed this value from ENV Varibles
  type = string
}

variable "TF_DBSUBNETGROUP" {
  ## passed this value from ENV Varibles
  type = string
}

variable "AWS_REGION" {
  type = string
}

variable "dynamodb_table_statelock"{
type = string

}
