require! \./AzureResource

module.exports = class NsgRule extends AzureResource
  commands:
    list: "network nsg rule list"
    create: "network nsg rule create"
  options:~ ->
    list:
      resource-group: @resource-group
      nsg-name: @nsg-name
    create:
      resource-group: @resource-group
      nsg-name: @nsg-name
      name: @name
      source-address-prefix: @source-address-prefix
      source-port-range: @source-port-range
      destination-address-prefix: @destination-address-prefix
      destination-port-range: @destination-port-range
      priority: @priority
      access: @access
      direction: @direction
