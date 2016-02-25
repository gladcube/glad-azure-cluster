require! \./AzureResource

module.exports = class LbFrontendIp extends AzureResource
  commands:
    list: "network lb frontend-ip list"
    create: "network lb frontend-ip create"
  options:~ ->
    list:
      resource-group: @resource-group
      lb-name: @lb-name
    create:
      resource-group: @resource-group
      lb-name: @lb-name
      name: @name
      public-ip-name: @public-ip-name




