require! \./AzureResource

module.exports = class Vnet extends AzureResource
  resource-group: ""
  location: ""
  name: ""
  address-prefixes: ""
  commands:
    list: "network vnet list"
    create: "network vnet create"
  options:~ ->
    list:
      resource-group: @resource-group
    create:
      resource-group: @resource-group
      location: @location
      name: @name
      address-prefixes: @address-prefixes

