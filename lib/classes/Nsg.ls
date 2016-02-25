require! \./AzureResource

module.exports = class Nsg extends AzureResource
  commands:
    list: "network nsg list"
    create: "network nsg create"
  options:~ ->
    list:
      resource-group: @resource-group
    create:
      location: @location
      resource-group: @resource-group
      name: @name


