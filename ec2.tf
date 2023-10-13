name: Create an Azure VM
  hosts: localhost
  tasks:
    - name: Create a resource group
      azure_rm_resourcegroup:
        name: myResourceGroup
        location: eastus

 

    - name: Create an Azure VM
      azure_rm_virtualmachine:
        resource_group: myResourceGroup
        name: myVM
        location: eastus
        size: Standard_DS1_v2
        admin_username: Subhojit_agreeya@outlook.com
        admin_password: Subho_01
        image:
          offer: UbuntuServer
          publisher: Canonical
          sku: 18.04-LTS
      register: vm
