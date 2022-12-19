# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

#Create azure resource group
resource "azurerm_resource_group" "apache_terraform_rg" {
  name     = var.resource_group_name
  location = var.location

  lifecycle {
    prevent_destroy = false
  }
}

#Create virtual network for the VM
resource "azurerm_virtual_network" "apache_terraform_vnet" {
  name                = var.virtual_network_name
  location            = var.location
  address_space       = var.address_space
  resource_group_name = azurerm_resource_group.apache_terraform_rg.name
}

#Create subnet to the virtual network
resource "azurerm_subnet" "subnet" {
  name                 = "${var.prefix}_subnet"
  virtual_network_name = azurerm_virtual_network.apache_terraform_vnet.name
  resource_group_name  = azurerm_resource_group.apache_terraform_rg.name
  address_prefixes     = var.subnet_prefix
}

#Create public ip
resource "azurerm_public_ip" "apache_terraform_pip" {
  name                = "${var.prefix}-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.apache_terraform_rg.name
  allocation_method   = "Dynamic"
  domain_name_label   = var.hostname
}

#Create Network security group
resource "azurerm_network_security_group" "apache_terraform_sg" {
  name                = "${var.prefix}-sg"
  location            = var.location
  resource_group_name = azurerm_resource_group.apache_terraform_rg.name

  security_rule {
    name                       = "HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

#Create Network interface
resource "azurerm_network_interface" "apache_terraform_nic" {
  name                = "${var.prefix}-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.apache_terraform_rg.name

  ip_configuration {
    name                          = "${var.prefix}-ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.apache_terraform_pip.id
  }
}

#Create VM
resource "azurerm_virtual_machine" "azure_vm" {
  name                = var.hostname
  location            = var.location
  resource_group_name = azurerm_resource_group.apache_terraform_rg.name
  vm_size             = var.vm_size

  network_interface_ids         = ["${azurerm_network_interface.apache_terraform_nic.id}"]
  delete_os_disk_on_termination = "true"

  storage_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  storage_os_disk {
    name              = "${var.hostname}_osdisk"
    managed_disk_type = "Standard_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }

  os_profile {
    computer_name  = var.hostname
    admin_username = var.admin_username
    admin_password = var.admin_password
    custom_data    = file("user-data.sh")
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}