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

# Optional Azure auth inputs when using a Secret File tfvars in Jenkins
variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  default     = null
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
  default     = null
}

variable "client_id" {
  description = "Azure Service Principal app (client) ID"
  type        = string
  default     = null
}

variable "client_secret" {
  description = "Azure Service Principal client secret"
  type        = string
  sensitive   = true
  default     = null
}