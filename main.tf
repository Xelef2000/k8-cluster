data "template_file" "user_data" {
  count    = var.num_vms
  template = file("./cloud-init/user-data.cfg")
  vars = {
    pubkey   = file(pathexpand(var.ssh_pub_key_file))
    hostname = "k8-${count.index}"
    fqdn     = "k8-${count.index}.wg"
    username = var.ssh_user
  }
}

resource "local_file" "cloud_init_user_data_file" {
  count    = var.num_vms
  content  = data.template_file.user_data[count.index].rendered
  filename = "${path.module}/files/user_data_${count.index}.cfg"
}

resource "null_resource" "cloud_init_config_files" {
  count = var.num_vms
  connection {
    type     = "ssh"
    user     = var.px_user
    password = var.px_pw
    host     = var.px_host
  }

  provisioner "file" {
    source      = local_file.cloud_init_user_data_file[count.index].filename
    destination = "${var.userdata_remote_location}/user_data_vm-${count.index}.yml"
  }



}

resource "proxmox_vm_qemu" "k8-nodes" {
  count = var.num_vms
  depends_on = [
    null_resource.cloud_init_config_files,
  ]

  name        = "k8-${count.index}"
  desc        = "tf description"
  target_node = "hkm2"

  #clone    = "bullseye-cloud-init-template"
  clone    = "bullseye-cloud-init-small"
  agent    = 1
  os_type  = "cloud-init"
  cores    = 4
  sockets  = 1
  cpu      = "host"
  memory   = 4048
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"


  disk {
    slot     = 0
    size     = "30G"
    type     = "scsi"
    storage  = "local-lvm"
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


  ipconfig0 = "ip=${var.ip_address[count.index]}/24,gw=172.18.0.1"
  sshkeys   = file(var.ssh_pub_key_file)

  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = file(var.ssh_priv_key_file)
    host        = var.ip_address[count.index]
  }


  cicustom                = "user=local:snippets/user_data_vm-${count.index}.yml"
  cloudinit_cdrom_storage = "local-lvm"

}


# resource "null_resource" "kubespray-handover" {
#   depends_on = [
#     proxmox_vm_qemu.k8-nodes,
#   ]
  
#   command = "./configure-kubespray.sh -u ${var.ssh_user} -c ${var.cluster_name} -p \" ${join(" ", var.ip_address)} \" -i ${var.ssh_priv_key_file}"

# }