variable "resource_group_name" {
  description = "resource_group_name"
  type        = string
  default     = ""
}

variable "resource_group_location" {
  description = "resource_group_location"
  type        = string
  default     = ""
}

variable "virtual_network_name" {
  description = "virtual_network_name"
  type        = string
  default     = ""
}

variable "virtual_network_address_space" {
  description = "virtual_network_address_space"
  type        = list(string)
  default     = []
}

variable "enable_output" {
  description = "Enable/Disable module output"
  default     = true
}