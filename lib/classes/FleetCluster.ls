require! \./Rg.ls
require! \./Vnet.ls
require! \./CoreosCluster.ls

module.exports = class FleetCluster extends CoreosCluster
  # Interfaces
  name: ""
  size: 0
  rg: new Rg
  vnet: new Vnet
  subnet_address_prefix: ""
  storage_account_type: ""
  vm_size: ""
  tmp_dir: ""
  ssh_publickey_file: ""

  cloud_config_template_path: "#__dirname/../../cloud-config-templates/fleet-cluster.yml"
  nsg_rule_options:
    ssh:
      source_address_prefix: "'*'"
      source_port_range: "'*'"
      destination_address_prefix: "'*'"
      destination_port_range: 22
      priority: 1000
      access: \Allow
      direction: \Inbound
    fleet:
      source_address_prefix: "'*'"
      source_port_range: "'*'"
      destination_address_prefix: "'*'"
      destination_port_range: 49153
      priority: 1050
      access: \Allow
      direction: \Inbound
  probe_options:
    fleet:
      protocol: \TCP
      port: 49153
      path: \/
      interval: 5
      count: 2
  lb_rule_options:
    fleet:
      protocol: \TCP
      frontend_port: 49153
      backend_port: 49153
      idle_timeout: 4
      probe_name: \fleet
  process_template: (template, cb)->
    template
      .replace /{{cluster}}/, @name
      .replace /{{etcd-cluster-dns}}/, "#{@rg.name}-etcd"
      .replace /{{subnet}}/, @subnet_address_prefix
    |> -> cb null, it
