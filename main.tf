# Terraform provider for Kubernetes.

terraform {
  required_providers {
    proxmox   = {
      source  = "bpg/proxmox"
      version = ">= 0.70.0"
    }
    talos     = {
      source  = "siderolabs/talos"
      version = ">= 0.7.1"
    }
    helm = {
      source = "hashicorp/helm"
      version = ">= 2.17.0"
    }
  }
}

provider "proxmox" {
  endpoint  = "https://${var.pve_host}:8006"
  api_token = var.pve_api_token
  insecure  = true
}

provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
