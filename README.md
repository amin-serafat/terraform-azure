# Terraform Azure Infrastructure – Dev Environment

[![png drawio](https://github.com/user-attachments/assets/7dd8218f-baa8-483f-979e-1104574e33e8)](https://viewer.diagrams.net/?tags=%7B%7D&lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=1&title=Untitled%20Diagram.drawio&dark=auto#R%3Cmxfile%3E%3Cdiagram%20name%3D%22Page-1%22%20id%3D%22YnanW599VvQ5b90Q_jEQ%22%3E3Zrbbqs4FIafJpdB5pjkMoeme6TdUTUZtXvmJnLAIVYBI2Ny2E8%2FdjAQY5K0ndJGTaUUL4wx%2F7eWvWzSs6fx%2Fp7CdPNAAhT1LBDse%2FasZ1lDYPFvYTgUBtN1pSWkOJC22rDAv5E0AmnNcYAypSIjJGI4VY0%2BSRLkM8UGKSU7tdqaROpdUxgizbDwYaRbn3HANvK5XFDbfyAcbso7m0CeiWFZWRqyDQzI7sRk3%2FXsKSWEFUfxfooiIV6pS3Hd%2FMzZqmMUJew1Fyzwv3H09LzoE7v%2F93O2DuaB35cwtjDK5QPLzrJDqQCOjxJNYJYWAq%2FxHvE2JxsWR7xo8sOU4IQdlXYnPXcmakc4TLjB571DlBvWJGESr8mffSKbneE45H2O8Ip%2Fw985ReIRQpQgCnnv53%2BhjOTUR8t7SvI0M7JtyC%2BWvUaUof1ZOcxKZO6diMSI0QOvIi%2FwJBbpmCWlXQ3ZGxamzQlfz5GuJd0qrNqtlecHUvw3gHA1EOWTc%2Bvx2TUw%2FNmZikETXSiEuTOP5YkYB4G4fLLbYIYWKfRFWzseutzGb5IEguwMfIzEjqNpWoXHqag26EhU07nu3tkOxxFMhCgZg7T00Q%2BSYKR6mdviZXaLIg7oShL7NgM%2BQWxH6AtOxLlFvuLlt4T6Bfpn0VSueFC98MoI4ABjYHUEZ6DBKaToWR6MRYgmq0z8M4EBDNPgHZ5bzi2OC%2B%2FjMVR4DGqhT5F86vihAzkbLdkLYv5GivQJoRNnPuRzw%2FzpYfkTJ%2Fl%2B%2BSdJlmMRT10HTmNMM1sGtYFngJEOatAZqOF1UKXP%2F4QrFD2SDDNMhOorwhiJVUbN%2BGAkbeOUMUpe0JREhJdmCTnOImscRaWpx30TTO7mAiLP%2F1LRlXgfilTZgAUrRmjhQEe%2FQPRuiwr3MLtk6AD7OsSWUPM6Izi6TrAlci7EmU6rTMBFhAYw21RjWgPZfO6NATjHV%2BPI4xGu4NKPSB4Y0KfF0ZKvSBjEPI9dUhTiTIjUIdBmPmuOdKDO0PB0pK5ndJXUlkn1rWUbME2XGaJb7POlpTUf8%2BKiKC4feS74plXGu0ZQxwD26OTTSEReuRYZdoXtRleFX5AkOreXJFp6Cn8hS7S%2BWZbo3F6WaL1ilfkV4VJNQGKMm1az0R8JX%2BcmfOTrPHasZuy0BI%2FTMq6NugKlp%2FPH1Jmbnh6%2BS4CMhpfmltZ9rk8NFj1TX8gU%2BJsAcEw1tbZMz1CADL%2BYgJ5pV4MDN1fJamM2%2BS54jlkwOPlYKq22LbrPxGObGp56JRHe6kbw%2B%2BYHVXrb%2B%2BLIsPW89xmtxJ3SbyN6Y%2FPmyzW39BcfmtTKWp3kLOKxMK3e94ErFKLGfo%2BG5%2ByGUPsuUHP9v0OriIQkM0LMNvnqVeQuvzSwHTXH7Ztey%2B6Mq1MqbR9PybtOyc%2Fp9khJUEBJMBZvX4XeEcwy7KuUVG%2FnutDDL1Ew3LL4z%2Bm52V4pHZQoQYH2Cveq0idCui3uXtooiiDDW7X5NnXlHR5FCn8CcjAybK%2F%2BK2UsuQ4bvIoXfrKRGpne7shVGmruyjFIQ8S0djgReDipJhcc57vf2FPqO%2BByt5r1m2%2BkG%2FUd923tNxfj%2FZFSX%2BzkHJ%2Bw9vOK%2BP%2BYFPQ9rHvMfohAB2P%2FOGTc4NRwZYCx20Epb2qdj5kGeLH%2BjUMBpf6liH33Hw%3D%3D%3C%2Fdiagram%3E%3C%2Fmxfile%3E)



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


