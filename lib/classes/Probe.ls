require! \./AzureResource

module.exports = class Probe extends AzureResource
  commands:
    list: "network lb probe list"
    create: "network lb probe create"
  options:~ ->
    list:
      resource-group: @resource-group
      lb-name: @lb-name
    create:
      resource-group: @resource-group
      lb-name: @lb-name
      name: @name
      protocol: @protocol
      port: @port
      path: @path
      interval: @interval
      count: @count


