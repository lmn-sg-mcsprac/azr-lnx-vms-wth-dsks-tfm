existing_snet_info = {
  snet_resource_grp    = "sg-sap-rg"
  virtual_network_name = "hep-wus2-spoke-sap-vnet"
  snet_name            = "hep-wus2-dmz-snet"
}

vm_params = {
  existing_resource_group = "sg-sap-rg"
  source_image_reference = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

vm_list = {
  vm1 = {
    vmname         = "xzzxcz"
    vmsku          = "Standard_B2ms"
    admin_username = "adminuser"
    admin_password = "P@ssw0rd1234!"
    ip_offset      = "10"
    data_disks = {
      data1 = {
        storage_account_type = "Standard_LRS"
        # create_option = "Empty" # Optional -- Defaults to Empty if not specified
        disk_size_gb = "10"
        lun          = 1
        caching      = "ReadWrite"
        ## write_accelaration = "true" # Optional -- Defaults to false if not specified
      }
      data2 = {
        storage_account_type = "Standard_LRS"
        disk_size_gb         = "10"
        lun                  = 2
        caching              = "ReadWrite"
      }
    }
  }
  vm2 = {
    vmname         = "heswddws02"
    vmsku          = "Standard_B2ms"
    admin_username = "adminuser"
    admin_password = "P@ssw0rd1234!"
    ip_offset      = "11"
    data_disks = {
      data1 = {
        storage_account_type = "Standard_LRS"
        disk_size_gb         = "10"
        lun                  = 1
        caching              = "ReadWrite"
      }
      data2 = {
        storage_account_type = "Standard_LRS"
        disk_size_gb         = "10"
        lun                  = 2
        caching              = "ReadWrite"
      }
    }
  }
  vm3 = {
    vmname         = "newvm03"
    vmsku          = "Standard_B2ms"
    admin_username = "adminuser"
    admin_password = "P@ssw0rd1236!"
    ip_offset      = "13"
    data_disks = {
      data1 = {
        storage_account_type = "Standard_LRS"
        disk_size_gb         = "10"
        lun                  = 1
        caching              = "ReadWrite"
      }
    }
  }
}
