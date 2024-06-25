# variable "subscriptionID" {
#   type      = string
#   sensitive = true
# }

# variable "tenantid" {
#   type      = string
#   sensitive = true
# }
# variable "clientid" {
#   type      = string
#   sensitive = true
# }

# variable "clientsecret" {
#   type      = string
#   sensitive = true
# }

variable "resourceGroupName" {
  type    = string
  default = "farmpulse-test"
}

variable "location" {
  type    = string
  default = "East US"
}


variable "vnet_name" {
  description = "Name of the VNet"
  default     = "oneclick-vnet"
}

variable "vnet_address_space" {
  description = "Address space of the VNet"
  type        = list(string)
  default     = ["10.0.0.0/12"]
}

variable "subnet_names" {
  description = "Names of the subnets"
  type        = list(string)
  default     = ["oneclick-subnet-1", "oneclick-subnet-2"]
}

variable "subnet_prefixes" {
  description = "Prefixes of the subnets"
  type        = list(string)
  default     = ["10.0.0.0/20", "10.0.16.0/20"]
}

variable "nat_ipprefix_name" {
  type    = string
  default = "oneclick-nat-ip-prefix"
}

variable "nat_name" {
  type    = string
  default = "oneclick-nat"
}

variable "acr_name" {
  type    = string
  default = "farmpulseacr"
}

variable "public_network_access_enabled" {
  type    = bool
  default = false
}

variable "aks_cluster_name" {
  type    = string
  default = "oneclick-aks"
}

variable "aks_agents_availability_zones" {
  type    = list(string)
  default = ["1", "2", "3"]
}

variable "net_profile_dns_service_ip" {
  type    = string
  default = "10.0.32.10"
}

variable "net_profile_service_cidr" {
  type    = string
  default = "10.0.32.0/20"
}

variable "aks_prefix" {
  type    = string
  default = "oneclick"
}

# variable "key_vault_name" {
#   type = string
#   default = "vln-key-vault"
# }

variable "allowed_ip_addresses" {
  type = list(string)
  default = ["27.123.241.63","103.62.237.178"]
}