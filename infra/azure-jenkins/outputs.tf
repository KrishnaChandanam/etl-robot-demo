output "public_ip" {
  description = "Public IP address of the VM"
  value       = azurerm_public_ip.pip.ip_address
}

output "jenkins_url" {
  description = "Jenkins URL"
  value       = "http://${azurerm_public_ip.pip.ip_address}:${var.jenkins_port}"
}