require! \child_process
{exec, spawn} = child_process

module.exports = new class CliManager
  azure_bin_path: "#{__dirname}/../../node_modules/azure-cli/bin/azure"
  spawn: (cmd, options, cb)->
    | options |> is-type \Function => cb = &1; options = {}
    | &length < 3 => cb = ->
    | &length < 2 => options = {}; cb = ->
    spawn "#{@azure_bin_path}", (@parse cmd, options), stdio: \inherit
      ..on \close, cb
      ..on \error, -> console.log it
  exec: (cmd, options, cb)->
    | options |> is-type \Function => cb = &1; options = {}
    | &length < 3 => cb = ->
    | &length < 2 => options = {}; cb = ->
    console.log "#{@azure_bin_path} #{(@parse cmd, options) |> join " "}"
    err, stdin, stdout <- exec "#{@azure_bin_path} #{(@parse cmd, options) |> join " "}"
    cb err, stdin, stdout
  parse: (cmd, options)->
    (cmd |> split " ")
    |> (cmds)->
      options
      |> obj-to-pairs
      |> map ([key, val])-> ["--#{key |> dasherize}", val]
      |> concat
      |> (cmds ++ )
