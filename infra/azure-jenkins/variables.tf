variable "prefix" {
  description = "Name prefix for resources"
  type        = string
  default     = "etljenkins"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "jenkins"
}

variable "ssh_public_key" {
  description = "SSH public key (contents of ~/.ssh/id_rsa.pub)"
  type        = string
}

variable "vm_size" {
  description = "Azure VM size"
  type        = string
  default     = "Standard_B2s"
}

variable "jenkins_port" {
  description = "Port for Jenkins"
  type        = number
  default     = 8080
}