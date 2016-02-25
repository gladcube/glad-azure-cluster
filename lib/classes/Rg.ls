require! \./AzureResource

module.exports = class Rg extends AzureResource
  location: ""
  name: ""
  commands:
    list: "group list"
    create: "group create"
  options:~ ->
    list: {}
    create:
      location: @location
      name: @name

