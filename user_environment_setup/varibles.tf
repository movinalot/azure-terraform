variable "user_password" {
  description = ""
}

variable "user_principal_name_ext" {
  description = ""
}

variable "training_group" {
  description = "Training Group"
  default     = ""
}

variable "group_owners" {
  description = "Training Group Owners"
}

variable "enable_module_output" {
  description = "Enable/Disable module output"
  default     = true
}

variable "user_role_definition_names" {
  description = "List of roles to assign to users"
  default     = []
}

variable "resource_group_suffix" {
  description = "Resource Group Suffix, prefix is username"
  default     = ""
}