## Azure Jenkins VM (Terraform)

- Provisions an Ubuntu VM with Jenkins + Docker
- Opens SSH (`22`) and Jenkins (`8080`) via NSG
- Cloud-init installs Jenkins and starts services

### Prerequisites
- Azure CLI logged in: `az login`
- Terraform >= 1.5 installed
- An SSH public key available (e.g., `~/.ssh/id_rsa.pub`)

### Authentication (no hardcoding creds)
- Recommended: Azure CLI login — Terraform will use your CLI context automatically. Set the subscription if needed:
	- `az login`
	- `az account set --subscription <SUBSCRIPTION_ID>`
- Service Principal: export environment variables (do not commit them) or set them in your CI as secrets:
	- `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_TENANT_ID`, `ARM_SUBSCRIPTION_ID`
	- Example:
		```bash
		export ARM_CLIENT_ID=<appId>
		export ARM_CLIENT_SECRET=<password>
		export ARM_TENANT_ID=<tenantId>
		export ARM_SUBSCRIPTION_ID=<subscriptionId>
		```
- Managed Identity (on Azure VM): assign an identity and set `ARM_USE_MSI=true`. The provider will use the VM identity.

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
- Do not hardcode credentials in `.tf` files. Use Azure CLI auth, environment variables, or managed identity.

### Jenkins Secret File (terraform.tfvars)
- In Jenkins → Credentials, create a credential of kind "Secret file" with ID `TFVARS_FILE` containing a `terraform.tfvars` file. Example content:
	- `subscription_id = "<your-sub-id>"`
	- `tenant_id       = "<your-tenant-id>"`
	- `client_id       = "<appId>"`
	- `client_secret   = "<password>"`
	- plus any variables from `variables.tf` (e.g., `ssh_public_key`, `location`, etc.)
- The pipeline stage in [Jenkinsfile](../../Jenkinsfile) will pass `-var-file` with this secret file so nothing is committed to Git.