terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.6"
    }
  }
}

provider "proxmox" {
  pm_api_url  = "https://hkm.wg:8006/api2/json"
  pm_password = var.px_pw
  pm_user     = var.px_user
}