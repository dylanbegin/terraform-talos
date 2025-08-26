# Terraform variables for kubernetes.

# secret variables
variable "pve_host"{
  type      = string
  sensitive = true
}

variable "pve_api_token" {
  type      = string
  sensitive = true
}

variable "pve_ssh_user" {
  type      = string
  sensitive = true
}

variable "pve_ssh_pass" {
  type      = string
  sensitive = true
}

variable "sshuser" {
  type      = string
  sensitive = true
}

variable "sshpass" {
  type      = string
  sensitive = true
}

variable "sshkey" {
  type      = list(string)
  sensitive = true
}

variable "vault_token" {
  type        = string
  description = "Vault secrets token for ESO"
  sensitive   = true
}

variable "vault_ica" {
  type        = string
  description = "Vault Intermidiate CA for ESO"
  sensitive   = true
}

# vm common settings
## vm general settings
variable "common-nodeprefix" {
  type        = string
  description = "Host node prefix for all CPU nodes."
}

variable "common-nodegpuprefix" {
  type        = string
  description = "Host node prefix for all GPU nodes."
}

variable "common-dns" {
  type        = list(string)
  description = "DNS servers for the VM to use."
}

variable "common-domain" {
  type        = string
  description = "Domain name for the VM."
}

variable "common-ostype" {
  type        = string
  description = "OS configuration type for all VMs."
}

variable "common-machine" {
  type        = string
  description = "The machine type for all VMs."
}

## vm hardware settings
variable "common-bios" {
  type        = string
  description = "BIOS type for the VM."
}

variable "common-cputype" {
  type        = string
  description = "CPU model name for the VM."
}

variable "common-cpusockets" {
  type        = number
  description = "CPU number of sockets for the VM."
}

variable "common-ballon" {
  type        = number
  description = "Memory ballon size in MB for the VM."
}

variable "common-vgatype" {
  type        = string
  description = "VGA graphic type attached to the VM."
}

variable "common-datastore" {
  type        = string
  description = "Datastore storage location for VM."
}

## vm networking settings
variable "common-ipv4gw" {
  type        = string
  description = "IPv4 gateway for the VM."
}

variable "common-cidr" {
  type        = string
  description = "IPv4 CIDR for the VM."
}

variable "common-bridge" {
  type        = string
  description = "VNIC bridge device name attached to the VM."
}

variable "common-model" {
  type        = string
  description = "VNIC device model type for the VM."
}

variable "common-fw" {
  type        = bool
  description = "VNIC Host Firewall state for the VM."
}

## vm cd settings
variable "common-cdiso" {
  type        = string
  description = "CD ISO attached for the VM."
}

variable "common-cdiface" {
  type        = string
  description = "CD interface attached type."
}

variable "common-ciiface" {
  type        = string
  description = "Cloud-init interface attached type."
}

## vm root disk settings
variable "common-scsihw" {
  type        = string
  description = "Disk SCSI device type for the VM."
}

variable "common-format" {
  type        = string
  description = "Disk format type for the VM."
}

variable "common-diskiface" {
  type        = string
  description = "Disk interface name for the VM."
}

variable "common-rootsize" {
  type        = string
  description = "Disk size in GB for root drive in the VM."
}

variable "common-ssd" {
  type        = bool
  description = "Disk ssd emulation option for the VM."
}

variable "common-cache" {
  type        = string
  description = "Disk cache settings for the VM."
}

variable "common-iothread" {
  type        = bool
  description = "Disk I/O thread option for the VM."
}

variable "common-discard" {
  type        = string
  description = "Disk discard option for the VM."
}

## vm efi disk settings
variable "common-efitype" {
  type        = string
  description = "EFI disk type for the VM."
}

variable "common-efikeys" {
  type        = bool
  description = "EFI keys enrollment state for the VM."
}

## vm options
variable "common-onboot" {
  type        = bool
  description = "VM power state on host boot."
}

variable "common-bootorder" {
  type        = list(string)
  description = "VM device boot order."
}

variable "common-agent" {
  type        = bool
  description = "VM qemu agent state."
}

variable "common-trim" {
  type        = bool
  description = "VM qemu agent trim state."
}

# master nodes
variable "master-count" {
  type        = number
  description = "Number of VM master nodes."
}

variable "master-idprefix" {
  type        = string
  description = "VM ID prefix for master nodes."
}

variable "master-nameprefix" {
  type        = string
  description = "VM hostname prefix for master nodes."
}

variable "master-desc" {
  type        = string
  description = "VM desctription for master nodes."
}

variable "master-tags" {
  type        = list(string)
  description = "List of all tags for master nodes."
}

variable "master-ipprefix" {
  type        = string
  description = "IPv4 address prefix for master nodes."
}

variable "master-cores" {
  type        = number
  description = "CPU number of cores for master nodes."
}

variable "master-memory" {
  type        = number
  description = "Memory size in MB for master nodes."
}

# gpu worker nodes (one per gpu pve host)
variable "workergpu-count" {
  type        = number
  description = "Number of VM worker gpu nodes."
}

variable "workergpu-idprefix" {
  type        = string
  description = "IPv4 address prefix for master nodes."
}

variable "workergpu-nameprefix" {
  type        = string
  description = "VM hostname prefix for worker gpu nodes."
}

variable "workergpu-desc" {
  type        = string
  description = "VM desctription for worker gpu nodes."
}

variable "workergpu-tags" {
  type        = list(string)
  description = "List of all tags for worker gpu nodes."
}

variable "workergpu-ipprefix" {
  type        = string
  description = "IPv4 address prefix for worker gpu nodes."
}

variable "workergpu-cores" {
  type        = number
  description = "CPU number of cores for worker gpu nodes."
}

variable "workergpu-memory" {
  type        = number
  description = "Memory size in MB for worker gpu nodes."
}

variable "workergpu-gpudevice" {
  type        = string
  description = "GPU device name for worker gpu nodes."
}

variable "workergpu-mapping" {
  type        = string
  description = "GPU mapping name for worker gpu nodes."
}

variable "workergpu-rombar" {
  type        = bool
  description = "GPU ROMbar option for worker gpu nodes."
}

variable "workergpu-pcie" {
  type        = string
  description = "GPU PCIe option for worker gpu nodes."
}

# worker nodes
variable "worker-count" {
  type        = number
  description = "Number of VM worker nodes."
}

variable "worker-idprefix" {
  type        = string
  description = "VM ID prefix for worker nodes."
}

variable "worker-nameprefix" {
  type        = string
  description = "VM hostname prefix for worker nodes."
}

variable "worker-desc" {
  type        = string
  description = "VM desctription for worker nodes."
}

variable "worker-tags" {
  type        = list(string)
  description = "List of all tags for worker nodes."
}

variable "worker-ipprefix" {
  type        = string
  description = "IPv4 address prefix for worker nodes."
}

variable "worker-cores" {
  type        = number
  description = "CPU number of cores for worker nodes."
}

variable "worker-memory" {
  type        = number
  description = "Memory size in MB for workers nodes."
}

variable "worker-datasize" {
  type        = string
  description = "Disk size in GB for data drive in the VM."
}

# talos settings
variable "talos-install" {
  type        = string
  description = "Talos Image Factory install image."
}

variable "talos-install-gpu" {
  type        = string
  description = "Talos Image Factory install image w/GPU."
}

variable "talos-version" {
  type        = string
  description = "Talos build version."
}

variable "kubernetes-version" {
  type        = string
  description = "Kubernetes build version."
}

variable "talos-cluster" {
  type        = string
  description = "Talos cluster name."
}

variable "talos-vipip" {
  type        = string
  description = "Talos cluster VIP IP."
}

variable "talos-vipfqdn" {
  type        = string
  description = "Talos cluster VIP FQDN."
}

variable "talos-podcidr" {
  type        = string
  description = "Talos cluster Pod CIDR."
}

variable "talos-svccidr" {
  type        = string
  description = "Talos cluster service CIDR."
}

variable "talos-clusterdns" {
  type        = string
  description = "Talos cluster DNS IP."
}

variable "talos-ntp" {
  type        = string
  description = "NTP server for talos cluster."
}

# manifest configs
variable "cilium-version" {
  type        = string
  description = "Cilium version."
}

variable "argocd-version" {
  type        = string
  description = "Argo-CD version."
}
