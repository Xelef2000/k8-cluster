terraform {
  cloud {
    organization = "felix-niederer-training"

    workspaces {
      name = "proxmox-k8"
    }
  }
}

