variable "location" {
  type = string
  description = "location of deployment"
}

variable "resource-group-name" {
  type = string
  description = "base name of resource group"
}

variable "common_tags" {
  type = map(string)
  description = "tags for resources"
}

variable "subnet-appgw-wl-id" {
  type = string
  description = "subnet of application gateway workload backend"
}

variable "subnet-apim-wl-id" {
  type = string
  description = "subnet of apim workload backend"
}

variable "subnet-jumphost-id" {
  type = string
  description = "subnet of jump host workload backend"
}

variable "ssk-key-pub-location" {
  type = string
  description = "ssh public key location"
}

variable "dns_name" {
  type = string
  description = "dns of server for www.xxx.yyy"
}

