# Terraform plan for Talos GPU worker nodes on Proxmox.

# Kubernetes Worker Nodes
resource "proxmox_virtual_environment_vm" "workergpu" {
  count = var.workergpu-count

  # VM general settings
  node_name      = "${var.common-nodegpuprefix}${count.index + 1}"
  vm_id          = "${var.workergpu-idprefix}${count.index +1}"
  name           = "${var.workergpu-nameprefix}${count.index +1}"
  description    = var.workergpu-desc
  tags           = var.workergpu-tags
  machine        = var.common-machine

  # VM CD for Talos boot
  cdrom {
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
        address  = "${var.workergpu-ipprefix}${count.index + 1}/${var.common-cidr}"
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
    cores        = var.workergpu-cores
  }
  memory {
    dedicated    = var.workergpu-memory
    shared       = var.common-ballon
  }
  hostpci {
    device  = var.workergpu-gpudevice
    mapping = var.workergpu-mapping
    rombar  = var.workergpu-rombar
    pcie    = var.workergpu-pcie
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
  # VM root disk
  disk {
    datastore_id = var.common-datastore
    file_format  = var.common-format
    interface    = var.common-diskiface
    size         = var.worker-datasize
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
  # VM data disk
  #disk {
  #  datastore_id = var.common-datastore
  #  file_format  = var.common-format
  #  interface    = "scsi1"
  #  size         = var.worker-datasize
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
