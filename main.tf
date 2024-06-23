###### NETWORK MODULE ######
terraform {
  #   required_version = ">= 1.0.1"
  required_providers {
    # see https://registry.terraform.io/providers/dmacvicar/libvirt
    # see https://github.com/dmacvicar/terraform-provider-libvirt
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = ">= 0.7.6"
    }
  }
}

##### VARIABLES #####
variable "kvm_subnet" {
  type    = string
  default = "172.16.0.0/24"
}

variable "network_name" {
  description = "A name to provide for the k8s cluster network"
  type        = string
  default     = "deault"
}

variable "dhcp_enabled" {
  description = "Enable DHCP for the k8s cluster network"
  type        = bool
  default     = false
}

variable "dns_enabled" {
  description = "Enable DNS for the k8s cluster network"
  type        = bool
  default     = true
}

variable "dns_local_only" {
  description = "Enable local only DNS for the k8s cluster network"
  type        = bool
  default     = false
}

variable "autostart_network" {
  description = "Autostart the k8s cluster network"
  type        = bool
  default     = true
}

variable "network_mode" {
  description = "The network mode for the k8s cluster network"
  type        = string
  default     = "nat"
}

##### RESOURCES #####

# see https://github.com/dmacvicar/terraform-provider-libvirt/blob/v0.7.1/website/docs/r/network.markdown
resource "libvirt_network" "cluster_net" {
  name      = var.network_name
  mode      = var.network_mode
  domain    = "${var.network_name}.test"
  addresses = [var.kvm_subnet]
  autostart = var.autostart_network
  dhcp {
    enabled = var.dhcp_enabled
  }
  dns {
    enabled    = var.dns_enabled
    local_only = var.dns_local_only
  }
}

##### OUTPUTS #####
output "network_id" {
  description = "ID of libvirt network"
  value       = libvirt_network.cluster_net.id
}

output "network_domain" {
  description = "Domain of libvirt network"
  value       = libvirt_network.cluster_net.domain
}
