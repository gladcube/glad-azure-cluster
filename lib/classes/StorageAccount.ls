require! \../services/cli-manager
require! \./AzureResource

module.exports = class StorageAccount extends AzureResource
  commands:~ ->
    list: "storage account list"
    create: "storage account create #{@name}"
  options:~ ->
    list:
      resource-group: @resource-group
    create:
      resource-group: @resource-group
      location: @location
      type: @type
  get_key: (cb)->
    err, res <~ cli-manager.exec "storage account keys list #{@name}", resource-group: @resource-group
    res.match /Primary: (\S+)/ ?.1
    |> ~> @key = it
    cb err, res



