require! \./AzureResource

module.exports = class Nic extends AzureResource
  commands:
    list: "network nic list"
    create: "network nic create"
  options:~ ->
    list:
      resource-group: @resource-group
    create:
      resource-group: @resource-group
      location: @location
      name: @name
      network-security-group-name: @nsg-name
      subnet-name: @subnet-name
      subnet-vnet-name: @subnet-vnet-name
      lb-address-pool-ids: @lb-address-pool-ids




