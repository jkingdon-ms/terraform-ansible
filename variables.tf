variable "location" {
  type    = string
  default = "eastus"
}

variable "resource_group_name" {
  type    = string
  default = "terraform-ansible-rg"
}

variable "virtual_network_name" {
  type    = string
  default = "vm-vnet"
}

variable "address_space" {
  type    = list(any)
  default = ["10.0.0.0/16"]
}

variable "prefix" {
  type    = string
  default = "jkingdon-webserver"
}

variable "subnet_prefix" {
  type    = list(any)
  default = ["10.0.1.0/24"]
}

variable "hostname" {
  type    = string
  default = "jkingdon-webserver-vm"
}

variable "vm_size" {
  type    = string
  default = "Standard_DS1_v2"
}

variable "image_publisher" {
  type    = string
  default = "Canonical"
}

variable "image_offer" {
  type    = string
  default = "UbuntuServer"
}

variable "image_sku" {
  type    = string
  default = "18.04-LTS"
}

variable "image_version" {
  type    = string
  default = "latest"
}

variable "admin_username" {
  type    = string
  default = "jkingdon"
}

variable "public_key" {
  type = string
}