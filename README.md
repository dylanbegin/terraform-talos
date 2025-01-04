> [!WARNING]
> This README is still under development!

# ![logo](https://icon.horse/icon/www.siderolabs.com) Terraform Repo for Kubernetes Cluster
> [!IMPORTANT]
> This repo is built for my own environment so please review all configurations to verify compatibility!

This repo provides all terraform automation for deploying the Talos Kubernetes cluster:
- Builds three master VMs across three Proxmox nodes.
- Builds three worker VMs across three Proxmox nodes.
- Builds one GPU VM on a fourth Proxmox node.
- Deploys the Talos cluster and stands up Kubernetes.
  - Uses several build extentions for Longhorn (all nodes) and NVIDIA gpu (on the GPU node).
  - Uses Cilium as the CNI.
  - Uses Argo-cd for git-ops.

> [!TIP]
> This repo is part of my IaC automation series. If you are building this in mind please follow my repo's in the order below.

1.  [terraform-iso-get](https://github.com/dylanbegin/terraform-iso-get)
1.  [packer](https://github.com/dylanbegin/packer)
1.  [terraform-core](https://github.com/dylanbegin/terraform-core)
1.  [ansible](https://github.com/dylanbegin/ansible)
1.  *you are here* [terraform-talos](https://github.com/dylanbegin/terraform-talos)
1.  [k8s-apps](https://github.com/dylanbegin/k8s-apps)

# Build Your Secrets File
Keeping in best practice, this repo does not contain any sensitive information. You will need to create a directory outside of this git repo on a properly encrypted disk/usb to save the secrets file. Below is the template needed for the file which needs to be named `tf-secrets.tfvars`.
```hcl
# This is a sensitive file. Do not share!
# All variables for all Terraform files.

pve_host      = "pve1.example.com:8006"
pve_api_token = "username@pam!build"
pve_ssh_user  = "username"
pve_ssh_pass  = "MY-PASSWORD"
sshuser       = "username"
sshpass       = "MY-PASSWORD"
sshkey        = ["ecdsa-sha2-nistp521 MY-SSH-KEY=="]
#base64 encoded: echo -n 'password' | base64
vault_token   = "MY-VAULT-TOKEN=="
#base64 vault-ica.crt
vault_ica    = "MY-PUBLIC-CERT=="
```

# Adjust Variables File
Adjust the `variables.tf` file to match your environemnt. Make sure you choose an INTERNAL ONLY domain that you own!

# Build the Repo
Once the core services are up and running we are now ready to deploy the Kubernetes cluster. In this stage we stand up the cluster and Argo-cd will build out you apps to be ready for use.
1. Go into Terraform directory: `cd ~/path-to/terraform-talos`
1. Initiate the workspace: `terraform init`
1. Validate the build: `terraform plan -var-file={path/to/secrets/}tf-secrets.tfvars`
1. Run the build: `terraform apply -var-file={path/to/secrets/}tf-secrets.tfvars -parallelism=2`

