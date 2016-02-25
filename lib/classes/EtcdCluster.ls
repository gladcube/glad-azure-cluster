require! <[http]>
require! \./Rg.ls
require! \./Vnet.ls
require! \./CoreosCluster

module.exports = class EtcdCluster extends CoreosCluster
  # Interfaces
  rg: new Rg
  vnet: new Vnet
  subnet_address_prefix: ""
  storage_account_type: ""
  vm_size: ""
  tmp_dir: ""

  cloud_config_template_path: "#__dirname/../../cloud-config-templates/etcd-cluster.yml"
  name: \etcd
  size: 3
  subnet_address_prefix: \10.10.0.0/16
  storage_account_type: \LRS
  vm_size: \Standard_A1
  nsg_rule_options:
    ssh:
      source_address_prefix: "'*'"
      source_port_range: "'*'"
      destination_address_prefix: "'*'"
      destination_port_range: 22
      priority: 1000
      access: \Allow
      direction: \Inbound
    http:
      source_address_prefix: "'*'"
      source_port_range: "'*'"
      destination_address_prefix: "'*'"
      destination_port_range: 80
      priority: 1010
      access: \Allow
      direction: \Inbound
    etcd:
      source_address_prefix: "'*'"
      source_port_range: "'*'"
      destination_address_prefix: "'*'"
      destination_port_range: 2379
      priority: 1040
      access: \Allow
      direction: \Inbound
  probe_options:
    etcd:
      protocol: \HTTP
      port: 2379
      path: \/v2/members
      interval: 5
      count: 2
  lb_rule_options:
    http:
      protocol: \TCP
      frontend_port: 80
      backend_port: 80
      idle_timeout: 4
      probe_name: \etcd
    etcd:
      protocol: \TCP
      frontend_port: 2379
      backend_port: 2379
      idle_timeout: 4
      probe_name: \etcd
  process_template: (template, cb)->
    res <~ http.get "http://discovery.etcd.io/new?size=#{@size}"
    res.set-encoding \utf-8
    token <~ res.on \data
    template
    |> ( .replace /DISCOVERY/, token)
    |> ~>
      cb null, it
