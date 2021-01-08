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
