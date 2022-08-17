variable "user_principal_name_ext" {
  description = "user_principal_name_ext"
  default     = ""
}

variable "user_password" {
  description = "user_password"
  default     = ""
}

variable "training_group_owners" {
  description = "List of accounts that own the training group"
  default     = []
}

variable "enable_module_output" {
  description = "Enable/Disable module output"
  default     = true
}