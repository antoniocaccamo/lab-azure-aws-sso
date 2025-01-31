



resource "azurerm_network_interface" "apim-wl-vm-linux-nic" {
  name = "apim-wl-vm-linux-nic"
  location = var.location
  resource_group_name = var.resource-group-name
  ip_configuration {
    name = "apim-wl-vm-linux-nic-cnf"
    subnet_id = var.subnet-apim-wl-id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "apim-wl-vm-linux" {

  name = "apim-wl-vm-linux"
  location = var.location
  resource_group_name = var.resource-group-name

  size                = "Standard_B2s"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.apim-wl-vm-linux-nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = var.ssk-key-pub-location
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(data.template_file.sdkman-vm-cloud-init.rendered)

  tags = var.common_tags
}


