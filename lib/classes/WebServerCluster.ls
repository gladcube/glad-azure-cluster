require! \./Rg.ls
require! \./Vnet.ls
require! \./FleetCluster

module.exports = class WebServerCluster extends FleetCluster
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

  nsg_rule_options:
    {}
      <<< FleetCluster::nsg_rule_options
      <<<
        http:
          source_address_prefix: "'*'"
          source_port_range: "'*'"
          destination_address_prefix: "'*'"
          destination_port_range: 80
          priority: 1010
          access: \Allow
          direction: \Inbound
        https:
          source_address_prefix: "'*'"
          source_port_range: "'*'"
          destination_address_prefix: "'*'"
          destination_port_range: 443
          priority: 1020
          access: \Allow
          direction: \Inbound
  probe_options:
    {}
      <<< FleetCluster::probe_options
      <<<
        http:
          protocol: \HTTP
          port: 80
          path: \/
          interval: 5
          count: 2
  lb_rule_options:
    {}
      <<< FleetCluster::lb_rule_options
      <<<
        http:
          protocol: \TCP
          frontend_port: 80
          backend_port: 80
          idle_timeout: 4
          probe_name: \http
        https:
          protocol: \TCP
          frontend_port: 443
          backend_port: 443
          idle_timeout: 4
          probe_name: \http
