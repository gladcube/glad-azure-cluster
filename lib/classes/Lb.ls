require! \./AzureResource

module.exports = class Lb extends AzureResource
  commands:
    list: "network lb list"
    create: "network lb create"
  options:~ ->
    list:
      resource-group: @resource-group
    create:
      resource-group: @resource-group
      location: @location
      name: @name




