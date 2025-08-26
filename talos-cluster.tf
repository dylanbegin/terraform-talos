# Talos cluster configuration.

# use locals to gather 1st master node ip
locals {
  controlplane_nodes = [for i in range(1, var.master-count + 1) : "${var.master-ipprefix}${i}"]
}

# prep cilium with helm template
data "helm_template" "cilium" {
  name         = "cilium"
  namespace    = "kube-system"
  repository   = "https://helm.cilium.io/"
  chart        = "cilium"
  version      = var.cilium-version
  kube_version = var.kubernetes-version
  values       = ["${file("configs/cilium-values.yml")}"]
  include_crds = true
}

# prep argocd with helm release
resource "helm_release" "argocd" {
  name         = "argo-cd"
  namespace    = "argocd"
  repository   = "https://argoproj.github.io/argo-helm"
  chart        = "argo-cd"
  version      = var.argocd-version
  values       = ["${file("configs/argocd-values.yml")}"]
}

# generate talos secret
resource "talos_machine_secrets" "tsecrets" {
  talos_version = var.talos-version
}

# generate controlplane machine config
data "talos_machine_configuration" "controlplane" {
  cluster_name       = var.talos-cluster
  cluster_endpoint   = "https://${var.talos-vipip}:6443"
  machine_type       = "controlplane"
  machine_secrets    = talos_machine_secrets.tsecrets.machine_secrets
  talos_version      = var.talos-version
  kubernetes_version = var.kubernetes-version
}

# apply controlplane machine config and patches including helmcharts
resource "talos_machine_configuration_apply" "controlplane" {
  depends_on = [proxmox_virtual_environment_vm.master]

  count    = var.master-count
  node     = "${var.master-ipprefix}${count.index + 1}"
  endpoint = "${var.master-ipprefix}${count.index + 1}"

  client_configuration        = talos_machine_secrets.tsecrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration

  config_patches = [
    templatefile("configs/masters.yml", {
      talos-cluster    = var.talos-cluster
      talos-clusterdns = var.talos-clusterdns
      talos-install    = var.talos-install
      talos-ntp        = var.talos-ntp
      talos-vipip      = var.talos-vipip
      talos-vipfqdn    = var.talos-vipfqdn
      talos-podcidr    = var.talos-podcidr
      talos-svccidr    = var.talos-svccidr
    }),
    yamlencode({
      cluster = {
        inlineManifests = [{
          name = "cilium"
          contents = join("---\n", [
            data.helm_template.cilium.manifest
          ]),
        }],
      },
    }),
    templatefile("configs/cilium-l2.yml", {
    }),
    templatefile("configs/argocd-ns.yml", {
    }),
    templatefile("configs/vault-secret.yml", {
      vault_token = var.vault_token
      vault_ica   = var.vault_ica
    })
  ]
}

# generate gpu worker machine config
data "talos_machine_configuration" "workergpu" {
  cluster_name       = var.talos-cluster
  cluster_endpoint   = "https://${var.talos-vipip}:6443"
  machine_type       = "worker"
  machine_secrets    = talos_machine_secrets.tsecrets.machine_secrets
  talos_version      = var.talos-version
  kubernetes_version = var.kubernetes-version
}

# apply gpu worker machine config and patches
resource "talos_machine_configuration_apply" "workergpu" {
  depends_on = [proxmox_virtual_environment_vm.workergpu]

  count    = var.workergpu-count
  node     = "${var.workergpu-ipprefix}${count.index + 1}"
  endpoint = "${var.workergpu-ipprefix}${count.index + 1}"

  client_configuration        = talos_machine_secrets.tsecrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.workergpu.machine_configuration

  config_patches = [
    templatefile("configs/workers.yml", {
      talos-cluster  = var.talos-cluster
      talos-install  = var.talos-install-gpu
      talos-ntp      = var.talos-ntp
    }),
    templatefile("configs/workersgpu.yml", {
    })
  ]
}

# generate standard worker machine config
data "talos_machine_configuration" "worker" {
  cluster_name       = var.talos-cluster
  cluster_endpoint   = "https://${var.talos-vipip}:6443"
  machine_type       = "worker"
  machine_secrets    = talos_machine_secrets.tsecrets.machine_secrets
  talos_version      = var.talos-version
  kubernetes_version = var.kubernetes-version
}

# apply standard worker machine config and patches
resource "talos_machine_configuration_apply" "worker" {
  depends_on = [proxmox_virtual_environment_vm.worker]

  count    = var.worker-count
  node     = "${var.worker-ipprefix}${count.index + 1}"
  endpoint = "${var.worker-ipprefix}${count.index + 1}"

  client_configuration        = talos_machine_secrets.tsecrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration

  config_patches = [
    templatefile("configs/workers.yml", {
      talos-cluster  = var.talos-cluster
      talos-install  = var.talos-install
      talos-ntp      = var.talos-ntp
    })
  ]
}

# bootstrap controlplane nodes off 1st master with combined config
resource "talos_machine_bootstrap" "bootstrap" {
  depends_on = [talos_machine_configuration_apply.controlplane]

  node                 = local.controlplane_nodes[0]
  endpoint             = local.controlplane_nodes[0]
  client_configuration = talos_machine_secrets.tsecrets.client_configuration
}

# generate client config
data "talos_client_configuration" "cc" {
  cluster_name         = var.talos-cluster
  endpoints            = [for nodes in local.controlplane_nodes : nodes]
  client_configuration = talos_machine_secrets.tsecrets.client_configuration
}

# gather kubeconfig from talos
resource "talos_cluster_kubeconfig" "kubeconfig" {
  depends_on = [talos_machine_bootstrap.bootstrap]

  node                 = local.controlplane_nodes[0]
  endpoint             = local.controlplane_nodes[0]
  client_configuration = talos_machine_secrets.tsecrets.client_configuration
}

# output ctl configs
output "kubeconfig" {
  value     = resource.talos_cluster_kubeconfig.kubeconfig.kubeconfig_raw
  sensitive = true
}

output "talosconfig" {
  value     = data.talos_client_configuration.cc.talos_config
  sensitive = true
}

# save config files to controller
resource "local_file" "kubeconfig" {
  content  = resource.talos_cluster_kubeconfig.kubeconfig.kubeconfig_raw
  filename = "${pathexpand("~/.kube/config")}"
  file_permission = "0640"
}

resource "local_file" "talosconfig" {
  content  = data.talos_client_configuration.cc.talos_config
  filename = "${pathexpand("~/.talos/config")}"
  file_permission = "0640"
}
