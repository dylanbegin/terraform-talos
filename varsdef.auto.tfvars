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
common-cputype    = "x86-64-v3"
common-cpusockets = 1
common-ballon     = 0
common-vgatype    = "std" #serial0 for TTY
common-datastore  = "anshar"
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
common-bootorder  = ["scsi0", "ide2"] #boot to talos iso
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
worker-datasize   = "950"

# talos cluster configs
# installed extentions: iscsi-tools, qemu-guest-agent, util-linux-tools
talos-cluster      = "talosprod"
talos-vipip        = "10.10.10.60"
talos-vipfqdn      = "vip.cryogence.org"
talos-podcidr      = "10.11.0.0/16"
talos-svccidr      = "10.12.0.0/16"
talos-clusterdns   = "10.12.0.5"
talos-ntp          = "pool.ntp.org"

# package versions
# iscsi-tools, qemu-guest-agent, util-linux-tools
talos-install      = "factory.talos.dev/installer/88d1f7a5c4f1d3aba7df787c448c1d3d008ed29cfb34af53fa0df4336a56040b:v1.9.3"
# iscsi-tools, nonfree-kmod-nvidia-production, nvidia-container-toolkit-production, qemu-guest-agent, util-linux-tools
talos-install-gpu  = "factory.talos.dev/installer/c35d5bd14fd96abc839f9f44f5effd00c48f654edb8a42648f4b2eb6051d1dd6:v1.9.3"
talos-version      = "v1.9.3"
kubernetes-version = "v1.32.1"
cilium-version     = "1.17.0"
argocd-version     = "8.3.0"
