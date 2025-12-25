## Azure Jenkins VM (Terraform)

- Provisions an Ubuntu VM with Jenkins + Docker
- Opens SSH (`22`) and Jenkins (`8080`) via NSG
- Cloud-init installs Jenkins and starts services

### Prerequisites
- Azure CLI logged in: `az login`
- Terraform >= 1.5 installed
- An SSH public key available (e.g., `~/.ssh/id_rsa.pub`)

### Usage
```bash
cd infra/azure-jenkins
terraform init
terraform plan -var "ssh_public_key=$(cat ~/.ssh/id_rsa.pub)"
terraform apply -auto-approve -var "ssh_public_key=$(cat ~/.ssh/id_rsa.pub)"
```

Outputs include the `jenkins_url`. First-time admin password is in:
`/var/lib/jenkins/secrets/initialAdminPassword`

### SSH into the VM
```bash
ssh -i ~/.ssh/id_rsa jenkins@$(terraform output -raw public_ip)
```

### Clean up
```bash
terraform destroy -auto-approve -var "ssh_public_key=$(cat ~/.ssh/id_rsa.pub)"
```

Notes:
- For production, restrict NSG source addresses instead of `0.0.0.0/0`.
- Change `location`, `vm_size`, and `prefix` in `variables.tf` as needed.