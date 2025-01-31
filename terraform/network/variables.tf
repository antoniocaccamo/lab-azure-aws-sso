variable "location" {
  type = string
  description = "location of deployment"
}

variable "base_name" {
  type = string
  description = "base name of resource group"
}

variable "common_tags" {
  type = map(string)
  description = "tags for resources"
}

variable "my_ip" {
  type = string
  description = "my public ip (X.X.X.X/)"
}