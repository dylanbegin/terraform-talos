# Terraform plan for Talos master nodes on Proxmox.

# Kubernetes Master Nodes
resource "proxmox_virtual_environment_vm" "master" {
  count = var.master-count

  # VM general settings
  node_name   = "${var.common-nodeprefix}${count.index + 1}"
  vm_id       = "${var.master-idprefix}${count.index + 1}"
  name        = "${var.master-nameprefix}${count.index + 1}"
  description = var.master-desc
  tags        = var.master-tags
  machine     = var.common-machine

  # VM CD for Talos boot
  cdrom {
    enabled   = var.common-cd
    file_id   = var.common-cdiso
    interface = var.common-cdiface
  }

  # VM cloud-init configuration
  initialization {
    datastore_id = var.common-datastore
    interface    = var.common-ciiface
    dns {
      servers    = var.common-dns
      domain     = var.common-domain
    }
    ip_config {
      ipv4 {
        address  = "${var.master-ipprefix}${count.index + 1}/${var.common-cidr}"
        gateway  = var.common-ipv4gw
      }
    }
  }

  # VM OS type
  operating_system {
    type = var.common-ostype
  }

  # VM hardware options
  bios           = var.common-bios
  cpu {
    type         = var.common-cputype
    sockets      = var.common-cpusockets
    cores        = var.master-cores
  }
  memory {
    dedicated    = var.master-memory
    shared       = var.common-ballon
  }
  vga {
    type         = var.common-vgatype
  }
  # VLAN DATA
  network_device {
    bridge       = var.common-bridge
    model        = var.common-model
    firewall     = var.common-fw
  }
  scsi_hardware  = var.common-scsihw
  disk {
    datastore_id = var.common-datastore
    file_format  = var.common-format
    interface    = var.common-diskiface
    size         = var.common-rootsize
    ssd          = var.common-ssd
    cache        = var.common-cache
    iothread     = var.common-iothread
    discard      = var.common-discard
  }
  efi_disk {
    datastore_id = var.common-datastore
    file_format  = var.common-format
    type         = var.common-efitype
    pre_enrolled_keys = var.common-efikeys
  }
  # VM options
  on_boot        = var.common-onboot
  boot_order     = var.common-bootorder
  agent {
    enabled      = var.common-agent
    trim         = var.common-trim
  }
}
