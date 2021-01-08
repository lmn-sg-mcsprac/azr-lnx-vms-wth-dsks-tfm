## Terraform Template to deploy multiple azure Linux vm's with static IP's and multiple disks

This terraform folder contains `HCL` code and a sample `tfvars` file to deploy multiple Linux variant azure VM's with Multiple Data Disks and 1 Network adapter with Static NIC

### Assumptions
 - This deployment assumes that you shall be deploying Azure Linux Vm's to existing **Subnet** and **Resource Group**
 - You plan to assign Static IP addresses to the VM's that are being deployed
 - You plan to use datadisks for your VM's


### What you need gather before using this terraform template
- Collect the **NAME** of `Subnet` , `VNET` that has this subnet and the `Resource Group` that is hosting these Network objects 
- Collect the **NAME** of the `Resource Group` you plan to put your newly created VM's
- Prepare a list of the `VM Names` you plan to deploy and the `IP-Addresses (HOST NUMBERS)` you plan to assign

### Things you may want to update in `main.tf`
- If you plan to use Azure Storage Backend, update the backend variables in `main.tf`

### Sample VM INPUT Params

```
# You are required to input the subnet and the VM resource group info before you can deploy vm's

vm1 = {
    vmname         = "your vm1 name"
    vmsku          = "Standard_B2ms"
    admin_username = "adminuser"
    admin_password = "Y0urSuperStr0ngP@ssword"
    ip_offset      = "10" ## This the HOST number you want to assign from the available IP prefix on the subnet.
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
        storage_account_type = "Premium_LRS"
        disk_size_gb         = "10"
        lun                  = 2
        caching              = "ReadWrite"
      }
    }
  }
  vm2 = {...}
  ```
