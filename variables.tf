variable "num_vms"{
  type = number
  default = 1
}

variable "ip_address"{
  type = list(string)
}

variable "ssh_user" {
  type = string
}


variable "px_user" {
  type = string
}

variable "px_pw" {
  type = string
}


variable "ssh_pub_key_file" {
  description = "The Public Key used for provisioned VMs using Cloud-Init"
  type        = string
}

variable "ssh_priv_key_file" {
  description = "The Private Key used for provisioned VMs using Cloud-Init"
  type        = string
}