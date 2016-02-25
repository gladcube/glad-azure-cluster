require! \./AzureResource

module.exports = class Vm extends AzureResource
  commands:
    list: "vm list"
    create: "vm create"
  options:~ ->
    list:
      resource-group: @resource-group
    create:
      resource-group: @resource-group
      location: @location
      name: @name
      nic-name: @nic-name
      ssh-publickey-file: @ssh-publickey-file
      os-type: @os-type
      image-urn: @image-urn
      admin-username: @admin-username
      vm-size: @vm-size
      availset-name: @availset-name
      storage-account-name: @storage-account-name
      custom-data: @custom-data




