require! \./AzureResource

module.exports = class PublicIp extends AzureResource
  commands:
    list: "network public-ip list"
    create: "network public-ip create"
  options:~ ->
    list:
      resource-group: @resource-group
    create:
      resource-group: @resource-group
      location: @location
      name: @name
      domain-name-label: @domain-name-label



