# Terraform Azure Infrastructure – Dev Environment

![jpg](https://github.com/user-attachments/assets/c484db16-0c94-409e-98b7-bf0c5a131ebf)

This project provisions a complete Azure environment for development, including:

- Resource Group  
- Virtual Network & Subnets (via a local module)  
- Network Security Group  
- Linux VM  
- Storage Account  
- Azure Container Registry  
- App Service Plan & Linux Web App (container-based)  
- Azure Container Instance  
- public SSH key at ~/.ssh/id_rsa.pub for the VM module.
- Docker image called myapp:latest pushed to ACR after apply

---


```
terraform-azure/
└── envs/
    └── dev/
        ├── main.tf            
        └── backend.tf        
└── modules/
    ├── network/              # VNet/subnet module
    ├── security/             # NSG module
    ├── compute/              # VM module
    └── storage/              # Storage Account module

```

## Configuration
Review & customize resource names in envs/dev/main.tf:

- Resource Group rg-dev
- Storage Account name (amin)
- ACR name (amintest)
- Web App name (amin)
- ACI DNS label (dev-aci)
- VM SSH CIDR (0.0.0.0/0)


## Deployment Steps

### Initialize Terraform
- cd envs/dev
     - terraform init

### Validate & Format

- terraform fmt 
- terraform validate

### Generate & Review Plan

- terraform plan -out=plan.tfplan

### Apply

- terraform apply plan.tfplan


