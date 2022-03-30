terraform {
  cloud {
    organization = "felix-niederer-training"

    workspaces {
      name = "proxmox-k8"
    }
  }
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      #only update if you have fast storage or a really small cloud init img,or this issue (https://github.com/Telmate/terraform-provider-proxmox/issues/431) is fixed
      #downgrade again to 2.8 if you get "Error: vm locked, could not obtain config"
      version = "2.8"
    }
  }
}





provider "proxmox" {
  pm_api_url      = "https://hkm2.wg:8006/api2/json"
  pm_password     = var.px_pw
  pm_user         = "${var.px_user}@pam"
  pm_tls_insecure = true
}