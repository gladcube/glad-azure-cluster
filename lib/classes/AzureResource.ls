require! \../services/cli-manager

module.exports = class AzureResource
  -> @ <<< it
  name: ""
  commands:
    list: ""
    create: ""
  options:
    list: {}
    create: {}
  create_if_doesnt_exist: (cb)->
    err <~ @find
    if not err? then cb.apply null, &; return
    <~ @create
    cb.apply null, &
  find: (cb)->
    _, res <~ cli-manager.exec @commands.list, @options.list
    if res.match (RegExp " #{@name} ") then cb.apply null, &
    else cb "Not found"
  create: (cb)->
    <~ cli-manager.exec @commands.create, @options.create
    cb.apply null, &



