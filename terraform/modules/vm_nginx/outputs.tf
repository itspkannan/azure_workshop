output "vm_id" {
  value = azurerm_linux_virtual_machine.vm.id
}

output "nic_id" {
  value = azurerm_network_interface.vm_nic.id
}
