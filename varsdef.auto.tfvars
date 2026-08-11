# All variable definitions for the build.

# common vaiables for all vms
## vm general settings
common-nodeprefix    = "pve"
common-nodegpuprefix = "gpu"
common-dns        = ["10.10.10.21", "10.10.10.22"]
common-domain     = "cryogence.org"
common-ostype     = "l26"
common-machine    = "q35"
## vm hardware settings
common-bios       = "ovmf"
common-cputype    = "host"
common-cpusockets = 1
common-ballon     = 0
common-vgatype    = "std" #serial0 for TTY
common-datastore  = "local-lvm"
## vm networking settings
common-ipv4gw     = "10.10.10.1"
common-cidr       = "24"
common-bridge     = "vmbr1"
common-model      = "virtio"
common-fw         = false
## vm cd settings
common-cdiso      = "nomad:iso/talos.iso" #<datastore>:iso/<iso-file>
common-cdiface    = "ide2"
common-ciiface    = "ide0"
## vm root disk settings
common-scsihw     = "virtio-scsi-single"
common-format     = "raw"
common-diskiface  = "scsi0"
common-rootsize   = "10"
common-ssd        = true
common-cache      = "none"
common-iothread   = true
common-discard    = "on"
## vm efi disk settings
common-efitype    = "4m"
common-efikeys    = false
## vm options
common-onboot     = true
common-bootorder  = ["scsi0", "ide2"]
common-agent      = true
common-trim       = true

# master nodes
master-count      = 3
master-idprefix   = "16"  #161-163
master-nameprefix = "k8s-m" #k8s-m1 - k8s-m3
master-desc       = "Kubernetes Master<br>Talos Linux"
master-tags       = ["k8s", "master"]
master-ipprefix   = "10.10.10.6" #10.10.10.61-10.10.10.63
master-cores      = 4
master-memory     = 4096

# gpu worker nodes
workergpu-count      = 1
workergpu-idprefix   = "18"  #181-182
workergpu-nameprefix = "k8s-g" #k8s-g1 - k8s-g2
workergpu-desc       = "Kubernetes GPU Worker<br>Talos Linux"
workergpu-tags       = ["k8s", "gpu", "worker"]
workergpu-ipprefix   = "10.10.10.8" #10.10.10.81-10.10.10.82
workergpu-cores      = 6
workergpu-memory     = 20480
workergpu-gpudevice  = "hostpci0"
workergpu-mapping    = "gpu" #name of mapping made in pve
workergpu-rombar     = true
workergpu-pcie       = true

# worker nodes
worker-count      = 3
worker-idprefix   = "17"  #171-176
worker-nameprefix = "k8s-w" #k8s-w1 - k8s-w6
worker-desc       = "Kubernetes Worker<br>Talos Linux"
worker-tags       = ["k8s", "worker"]
worker-ipprefix   = "10.10.10.7" #10.10.10.71-10.10.10.76
worker-cores      = 10
worker-memory     = 56320
worker-datastore  = "anshar"
worker-datasize   = "900"

# talos cluster configs
talos-cluster      = "talosprod"
talos-vipip        = "10.10.10.60"
talos-vipfqdn      = "vip.cryogence.org"
talos-podcidr      = "10.11.0.0/16"
talos-svccidr      = "10.12.0.0/16"
talos-clusterdns   = "10.12.0.5"
talos-ntp          = "pool.ntp.org"

# package versions
# command-line: console=ttyS0 net.ifnames=0 ipv6.disable=1
# amd-ucode intel-ucode gvisor iscsi-tools qemu-guest-agent util-linux-tools
talos-install      = "factory.talos.dev/nocloud-installer/968a7c25daaff07ab0478c19b89bccf55892ad85e91a2ddaa8c225d7000c0897:v1.13.8"
# + nonfree-kmod-nvidia-production, nvidia-container-toolkit-production
talos-install-gpu  = "factory.talos.dev/nocloud-installer/56e56e3dd5f7a768fadbc58a0784dddea1aafa3891216327fe7532480f7953c1:v1.13.8"
talos-version      = "v1.13.8"
kubernetes-version = "v1.36.2"
cilium-version     = "1.20.0"
argocd-version     = "10.3.0"
