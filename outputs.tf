output "kubespray-configuration" {
  value = "./configure-kubespray.sh  -c ${var.cluster_name} -p \"${join(" ", var.ip_address)}\" "
}

output "kubespray-run" {
  value = "./run-kubespray.sh -u ${var.ssh_user} -c ${var.cluster_name} -i ${var.ssh_priv_key_file}"
}


output "ip-adresses-list" {
  value = "${join(" ", var.ip_address)}"
}

output "node-username" {
  value = var.ssh_user
}

output "cluster_name" {
  value =var.cluster_name
}

output "ssh_priv_key" {
  value = var.ssh_priv_key_file
}