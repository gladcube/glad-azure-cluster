require! \./AzureResource.ls

module.exports = class Disk extends AzureResource
  commands:
    list: "vm disk list"
    create: "vm disk attach-new"
  options:~ ->
    list:
      resource-group: @resource-group
      vm-name: @vm-name
    create:
      resource-group: @resource-group
      vm-name: @vm-name
      size-in-gb: @size-in-gb
      vhd-name: @name
      host-caching: @host-caching
      storage-account-name: @storage-account-name
      storage-account-container-name: @storage-account-container-name
      lun: @lun





