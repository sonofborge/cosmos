provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_api_terraform_token_id
  pm_api_token_secret = var.proxmox_api_terraform_token_secret
  pm_tls_insecure     = true
}

resource "proxmox_vm_qemu" "dockserv" {
  count = 1
  name  = "dockserv-${count.index + 1}"

  target_node = var.proxmox_node
  clone       = "xsob-ubuntu-server-jammy-v1.0.3"

  agent    = 1
  bootdisk = "scsi0"
  cores    = 2
  cpu      = "host"
  os_type  = "cloud-init"
  memory   = 8192
  scsihw   = "virtio-scsi-pci"
  sockets  = 1

  disk {
    slot     = 0
    size     = "100G"
    type     = "scsi"
    storage  = "tank"
    iothread = 1
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=192.168.1.9${count.index + 1}/24,gw=192.168.1.1"

  connection {
    type     = "ssh"
    user     = "xsob"
    password = var.primary_user_password
    host     = "192.168.1.56"
  }

  provisioner "remote-exec" {
    inline = [
      "git clone https://github.com/sonofborge/dockserv.git /home/xsob/dockserv",
      "echo '${var.primary_user_password}' | sudo -S mkdir /media/nas"
    ]
  }
}
