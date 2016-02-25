require! <[glad-azure-cluster]>
{cli_manager, Rg, Vnet, EtcdCluster, FleetCluster} = glad-azure-cluster
rg = new Rg do
  name: \example
  location: \japanwest
vnet = new Vnet do
  resource-group: rg.name
  location: rg.location
  name: \main
  address-prefixes: \10.0.0.0/8
etcd_cluster = new EtcdCluster do
  rg: rg
  vnet: vnet
  subnet_address_prefix: \10.10.0.0/16
  storage_account_type: \LRS
  vm_size: \Standard_A1
  tmp_dir: "path/to/tmp_dir"
  ssh_publickey_file: "path/to/ssh_publickey_file"
example_fleet_cluster = new FleetCluster do
  name: \example-fleet
  size: 2
  rg: rg
  vnet: vnet
  subnet_address_prefix: \10.20.0.0/16
  storage_account_type: \LRS
  vm_size: \Standard_A2
  tmp_dir: "path/to/tmp_dir"
  ssh_publickey_file: "path/to/ssh_publickey_file"

err, res <- rg.create_if_doesnt_exist
console.log (err or res)
err, res <- vnet.create_if_doesnt_exist
console.log (err or res)
err, res <- etcd_cluster.create_if_doesnt_exist
console.log (err or res)
err, res <- example_fleet_cluster.create_if_doesnt_exist
console.log (err or res)



