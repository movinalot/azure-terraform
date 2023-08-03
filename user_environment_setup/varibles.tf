variable "user_principal_name_ext" {
  description = "user_principal_name_ext"
  default     = ""
}

variable "user_password" {
  description = "user_password"
  default     = ""
}

variable "user_prefix" {
  description = "username prefix"
  default     = "user"
}

variable "user_count" {
  description = "number of users"
  default     = 0
}

variable "user_start" {
  description = "nubmer to start users from"
  default     = 1
}

variable "training_group_owners" {
  description = "List of accounts that own the training group"
  default     = []
}

variable "enable_module_output" {
  description = "Enable/Disable module output"
  default     = true
}
