require! \./AzureResource

module.exports = class LbRule extends AzureResource
  commands:
    list: "network lb rule list"
    create: "network lb rule create"
  options:~ ->
    list:
      resource-group: @resource-group
      lb-name: @lb-name
    create:
      resource-group: @resource-group
      lb-name: @lb-name
      name: @name
      protocol: @protocol
      frontend-port: @frontend-port
      backend-port: @backend-port
      probe-name: @probe-name
      frontend-ip-name: @frontend-ip-name
      backend-address-pool: @backend-address-pool




