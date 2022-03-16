resource "proxmox_vm_qemu" "minecraft_server" {
  count = var.num_vms                       
  name  = "minecraft-test-${count.index + 1}"
  target_node = "hkm1"

  clone = "bullseye-cloud-ini-template"

  agent    = 1
  os_type  = "cloud-init"
  cores    = 4
  sockets  = 1
  cpu      = "host"
  memory   = 4048
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"
  disk {
    slot = 0
    size     = "30G"
    type     = "scsi"
    storage  = "local-lvm"
    iothread = 1
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
    #does not work?
    #macaddr = "fe80::b06b:ff:feb5:50${count.index + 1}"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }


  ipconfig0 = "ip=${var.ip_address[count.index]}/24,gw=172.18.0.1"
  sshkeys = file(var.ssh_pub_key_file)

  connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.ssh_priv_key_file)
      host        = var.ip_address[count.index]
    }

  provisioner "remote-exec" {
    
    inline = [
      "ip a",
    ]
  }
}