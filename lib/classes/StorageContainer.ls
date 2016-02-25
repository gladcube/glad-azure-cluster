require! \./AzureResource

module.exports = class StorageContainer extends AzureResource
  commands:~ ->
    list: "storage container list"
    create: "storage container create #{@name}"
  options:~ ->
    list:
      account-name: @account-name
      account-key: @account-key
    create:
      account-name: @account-name
      account-key: @account-key
      permission: @permission
