require! \./AzureResource

module.exports = class Subnet extends AzureResource
  commands:
    list: "network vnet subnet list"
    create: "network vnet subnet create"
  options:~ ->
    list:
      resource-group: @resource-group
      vnet-name: @vnet-name
    create:
      resource-group: @resource-group
      vnet-name: @vnet-name
      name: @name
      address-prefix: @address-prefix
      network-security-group-name: @nsg-name



