require! <[child_process fs path]>
{exec, spawn} = child_process

module.exports = new class CliManager
  get_bin_path: (base, cb)->
    base = path.resolve base
    err <~ fs.access (bin_path = "#base/node_modules/azure-cli/bin/azure"), fs.R_OK
    switch
    | not err? => cb null, bin_path
    | base is \/ => throw new Error "azure-cli not found."
    | _ => @get_bin_path "#base/..", cb
  spawn: (cmd, options, cb)->
    | options |> is-type \Function => cb = &1; options = {}
    | &length < 3 => cb = ->
    | &length < 2 => options = {}; cb = ->
    err, bin_path <~ @get_bin_path "#__dirname/../.."
    spawn "#{bin_path}", (@parse cmd, options), stdio: \inherit
      ..on \close, cb
      ..on \error, -> console.log it
  exec: (cmd, options, cb)->
    | options |> is-type \Function => cb = &1; options = {}
    | &length < 3 => cb = ->
    | &length < 2 => options = {}; cb = ->
    err, bin_path <~ @get_bin_path "#__dirname/../.."
    err, stdin, stdout <- exec "#{bin_path} #{(@parse cmd, options) |> join " "}"
    cb err, stdin, stdout
  parse: (cmd, options)->
    (cmd |> split " ")
    |> (cmds)->
      options
      |> obj-to-pairs
      |> map ([key, val])-> ["--#{key |> dasherize}", val]
      |> concat
      |> (cmds ++ )
  login: ->
    @spawn \login
