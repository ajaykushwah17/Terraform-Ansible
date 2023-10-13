resource "azurerm_virtual_machine" "example" {
  name                  = "myVM"
  location              = "East US"
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.example.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "myOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "azureuser"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFUeQxSYd+j62oq03FdqLdiXWduVDzcUbLDF8V+aBM9XXsYUpw0M9Xnc8Itxnz/Gua1YjQ+ZsF4hHJ0seA1"
    }
  }

  provisioner "file" {
    source      = "https://github.com/ajaykushwah17/Terraform-Ansible"
    destination = "/tmp/playbook.yml"
  }

  provisioner "local-exec" {
    command = "ansible-playbook /tmp/playbook.yml"
  }
}

resource "null_resource" "ansible_trigger" {
  triggers = {
    vm_id = azurerm_virtual_machine.example.id
  }

  provisioner "local-exec" {
    command = "echo Trigger Ansible here (replace this with your logic)"
  }
}
