# Terraform plan for Talos worker nodes on Proxmox.

# Kubernetes Worker Nodes
resource "proxmox_virtual_environment_vm" "worker" {
  count = var.worker-count

  # VM general settings
  node_name      = "${var.common-nodeprefix}${count.index + 1}"
  vm_id          = "${var.worker-idprefix}${count.index +1}"
  name           = "${var.worker-nameprefix}${count.index +1}"
  description    = var.worker-desc
  tags           = var.worker-tags
  machine        = var.common-machine

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
        address  = "${var.worker-ipprefix}${count.index + 1}/${var.common-cidr}"
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
    cores        = var.worker-cores
  }
  memory {
    dedicated    = var.worker-memory
    shared       = var.common-ballon
  }
  # GPU only on worker 1 (node 1) and worker 2 (node 2)
  #hostpci {
  #  mapping = var.worker-gpu
  #}
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
  # VM root disk
  disk {
    datastore_id = var.common-datastore
    file_format  = var.common-format
    interface    = var.common-diskiface
    size         = var.worker-disksize
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
  # VM data disk -- talos does not yet support longhorn v2
  #disk {
  #  datastore_id = var.common-datastore
  #  file_format  = var.common-format
  #  interface    = "scsi1"
  #  size         = var.worker-disksize
  #  ssd          = var.common-ssd
  #  cache        = var.common-cache
  #  iothread     = var.common-iothread
  #  discard      = var.common-discard
  #}
  # VM options
  on_boot        = var.common-onboot
  boot_order     = var.common-bootorder
  agent {
    enabled      = var.common-agent
    trim         = var.common-trim
  }
}
