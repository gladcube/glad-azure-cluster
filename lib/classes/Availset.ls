require! \./AzureResource

module.exports = class Availset extends AzureResource
  commands:
    list: "availset list"
    create: "availset create"
  options:~ ->
    list:
      resource-group: @resource-group
    create:
      resource-group: @resource-group
      location: @location
      name: @name




