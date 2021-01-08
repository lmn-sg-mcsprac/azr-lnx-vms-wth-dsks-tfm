data "azurerm_subnet" "subnet" {
  resource_group_name  = var.existing_snet_info.snet_resource_grp
  virtual_network_name = var.existing_snet_info.virtual_network_name
  name                 = var.existing_snet_info.snet_name
}

data "azurerm_resource_group" "rg" {
  name = var.vm_params.existing_resource_group
}

resource "azurerm_network_interface" "nic" {
  for_each                      = var.vm_list
  name                          = "${each.value.vmname}-nic"
  location                      = data.azurerm_resource_group.rg.location
  resource_group_name           = data.azurerm_resource_group.rg.name
  enable_accelerated_networking = false

  ip_configuration {
    name                          = "IPConfig1"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address            = cidrhost(data.azurerm_subnet.subnet.address_prefixes[0], each.value.ip_offset)
    private_ip_address_allocation = "static"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each                        = var.vm_list
  name                            = each.value.vmname
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = data.azurerm_resource_group.rg.location
  size                            = each.value.vmsku
  admin_username                  = each.value.admin_username
  admin_password                  = each.value.admin_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id
  ]

  source_image_reference {
    publisher = var.vm_params.source_image_reference.publisher
    offer     = var.vm_params.source_image_reference.offer
    sku       = var.vm_params.source_image_reference.sku
    version   = var.vm_params.source_image_reference.version
  }

  os_disk {
    storage_account_type = "Standard_LRS" ## Change to Premium for Production
    caching              = "ReadWrite"
  }
}


locals {
  ## This creates a tuple object with disk info for each VM created above
  vm_disks = flatten([
    for grpkeys, grpvals in azurerm_linux_virtual_machine.vm : [
      for grps, rules in var.vm_list : [
        for dskid, disk_parms in rules.data_disks : {
          "vmname" = rules.vmname
          "vm_id"  = grpvals.id
          ## Derive and add a diskname from vmname and disk key from the var.vm_list
          "disk_config" = merge(disk_parms, { "diskname" = "${rules.vmname}-${dskid}" })
        } if rules.vmname == grpvals.name
      ]
    ]
  ])
  ## This creates a map object with disk info from local.vmdisks
  vm_disk_map = { for items in local.vm_disks : items.disk_config.diskname => items }

  disk_to_vm_map = flatten([
    for grpkeys, grpvals in local.vm_disk_map : [
      for key, vals in azurerm_managed_disk.disks : {
        "vm_id"     = grpvals.vm_id
        "vmname"    = grpvals.vmname
        "disk_id"   = vals.id
        "disk_name" = grpvals.disk_config.diskname
        "lun_id"    = grpvals.disk_config.lun
       ## "write_accelaration" = try(grpvals.disk_config.write_accelaration, false)
        "caching"   = try(grpvals.disk_config.caching != null && grpvals.disk_config.caching != "" ? grpvals.disk_config.caching : "ReadWrite", "")
      } if grpvals.disk_config.diskname == key
    ]
  ])
}

resource "azurerm_managed_disk" "disks" {
  for_each             = local.vm_disk_map
  name                 = each.value.disk_config.diskname
  location             = data.azurerm_resource_group.rg.location
  resource_group_name  = data.azurerm_resource_group.rg.name
  create_option        = try(each.value.create_option, "Empty")
  storage_account_type = each.value.disk_config.storage_account_type
  disk_size_gb         = each.value.disk_config.disk_size_gb
}

resource "azurerm_virtual_machine_data_disk_attachment" "attach" {
  for_each                  = { for items in local.disk_to_vm_map : items.disk_name => items }
  managed_disk_id           = each.value.disk_id
  virtual_machine_id        = each.value.vm_id
  caching                   = try(each.value.caching, "ReadWrite")
  write_accelerator_enabled = try(each.value.write_accelaration, false)
  lun                       = each.value.lun_id
}