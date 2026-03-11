# Exercise 2: Reusable Azure VM Terraform Module

## Project Structure
```
terraform-azure-vm/
├── Jenkinsfile                  # CI/CD pipeline
├── main.tf                      # Root - calls module for dev & staging
├── variables.tf                 # Root input variables
├── outputs.tf                   # Root outputs
├── terraform.tfvars             # Your variable values (DO NOT commit)
├── .gitignore
└── modules/
    └── vm/
        ├── main.tf              # VM, NIC, Public IP resources
        ├── variables.tf         # Module inputs
        └── outputs.tf           # Module outputs (vm_id, IPs)
```

## Jenkins Setup Steps

### 1. Add Azure Credentials in Jenkins
Go to: Jenkins → Manage Jenkins → Credentials → Add Credentials

Add these as **Secret Text**:
| ID | Value |
|----|-------|
| `AZURE_CLIENT_ID` | Your Service Principal App ID |
| `AZURE_CLIENT_SECRET` | Your Service Principal Secret |
| `AZURE_SUBSCRIPTION_ID` | Your Azure Subscription ID |
| `AZURE_TENANT_ID` | Your Azure Tenant ID |
| `SSH_PUBLIC_KEY` | Contents of your `~/.ssh/id_rsa.pub` |

### 2. Create Azure Service Principal
Run in PowerShell:
```powershell
az ad sp create-for-rbac --name "jenkins-terraform-sp" --role="Contributor" --scopes="/subscriptions/YOUR_SUBSCRIPTION_ID"
```
Save the output — it gives you clientId, clientSecret, tenantId.

### 3. Create Jenkins Pipeline Job
1. New Item → Pipeline
2. Under Pipeline → Definition: **Pipeline script from SCM**
3. SCM: **Git**
4. Repository URL: your GitHub repo URL
5. Script Path: `Jenkinsfile`
6. Save and Build

### 4. Update main.tf Backend
Replace `YOUR_STORAGE_ACCOUNT_NAME` in `main.tf` with your storage account from Exercise 1.

## Running Locally (Windows PowerShell)
```powershell
# Set Azure credentials
$env:ARM_CLIENT_ID="your-client-id"
$env:ARM_CLIENT_SECRET="your-client-secret"
$env:ARM_SUBSCRIPTION_ID="your-subscription-id"
$env:ARM_TENANT_ID="your-tenant-id"
$env:TF_VAR_ssh_public_key="ssh-rsa AAAA..."

# Run Terraform
terraform init
terraform plan
terraform apply
```

## Cleanup (avoid Azure charges)
```powershell
terraform destroy
```
