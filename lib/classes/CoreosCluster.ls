require! \./Rg.ls
require! \./Vnet.ls
require! \../classes/Cluster

module.exports = class CoreosCluster extends Cluster
  # Interfaces
  name: ""
  type: ""
  size: 0
  rg: new Rg
  vnet: new Vnet
  subnet_address_prefix: ""
  storage_account_type: ""
  vm_size: ""
  nsg_rule_options: {}
  probe_options: {}
  lb_rule_options: {}
  cloud_config_template_path: ""
  tmp_dir: ""
  process_template: (template, cb)->

  os_type: \Linux
  image_urn: \CoreOS:CoreOS:Beta:877.1.0
  admin_username: \core

