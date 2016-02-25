require! \./AzureResource

module.exports = class AddressPool extends AzureResource
  commands:
    list: "network lb address-pool list"
    create: "network lb address-pool create"
  options:~ ->
    list:
      resource-group: @resource-group
      lb-name: @lb-name
    create:
      resource-group: @resource-group
      lb-name: @lb-name
      name: @name




