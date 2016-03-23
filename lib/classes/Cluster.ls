require! <[async fs]>
require! \./Rg.ls
require! \./Vnet.ls
require! \./Nsg.ls
require! \./Subnet.ls
require! \./PublicIp.ls
require! \./Lb.ls
require! \./LbFrontendIp.ls
require! \./AddressPool.ls
require! \./Nic.ls
require! \./StorageAccount.ls
require! \./Availset.ls
require! \./Vm.ls
require! \./NsgRule.ls
require! \./Probe.ls
require! \./LbRule.ls
require! \./Disk.ls

module.exports = class Cluster
  -> @ <<< it

  # Interfaces
  name: ""
  size: 0
  rg: new Rg
  vnet: new Vnet
  subnet_address_prefix: ""
  storage_account_type: ""
  os_type: ""
  image_urn: ""
  admin_username: ""
  vm_size: ""
  nsg_rule_options: {}
  probe_options: {}
  lb_rule_options: {}
  cloud_config_template_path: ""
  tmp_dir: ""
  ssh_publickey_file: ""
  process_template: (template, cb)->
  has_disk: no
  disk_size: 0
  disk_caching: \None
  disk_container_name: ""

  domain_name_label:~ -> "#{@rg.name}-#{@name}"
  lb_address_pool_ids:~ -> "/subscriptions/02851cd1-0e23-4d4b-a778-61db292913cb/resourceGroups/#{@rg.name}/providers/Microsoft.Network/loadbalancers/#{@lb.name}/backendAddressPools/#{@address_pool.name}"
  storage_account_name:~ -> "#{@rg.name}#{@name.replace /-/g, ""}cluster"
  custom_data:~ -> "#{@tmp_dir}/#{@name}-cluster-cloud-config.yml"
  nsg:~ -> @_nsg ?= new Nsg resource-group: @rg.name, location: @rg.location, name: @name
  subnet:~ -> @_subnet ?= new Subnet resource-group: @rg.name, vnet-name: @vnet.name, name: @name, address-prefix: @subnet_address_prefix, nsg-name: @nsg.name
  public_ip:~ -> @_public_ip ?= new PublicIp resource-group: @rg.name, location: @rg.location, name: @name, domain-name-label: @domain_name_label
  lb:~ -> @_lb ?= new Lb resource-group: @rg.name, location: @rg.location, name: @name
  lb_frontend_ip:~ -> @_lb_frontend_ip ?= new LbFrontendIp resource-group: @rg.name, name: @name, lb-name: @lb.name, public-ip-name: @public_ip.name
  address_pool:~ -> @_address_pool ?= new AddressPool resource-group: @rg.name, name: @name, lb-name: @lb.name
  nics:~ ->
    @_nics ?=
      [0 til @size]
      |> map (index)~>
        new Nic resource-group: @rg.name, location: @rg.location, name: "#{@name}-#index", nsg-name: @nsg.name, subnet-name: @subnet.name, subnet-vnet-name: @vnet.name, lb-address-pool-ids: @lb_address_pool_ids
  storage_account:~ -> @_storage_account ?= new StorageAccount resource-group: @rg.name, location: @rg.location, name: @storage_account_name, type: @storage_account_type
  availset:~ -> @_availset ?= new Availset resource-group: @rg.name, location: @rg.location, name: @name
  vms:~ ->
    @_vms ?=
      [0 til @size]
      |> map (index)~>
        new Vm resource-group: @rg.name, location: @rg.location, name: "#{@name}-#index", nic-name: @nics.(index).name, ssh-publickey-file: @ssh_publickey_file, os-type: @os_type, image-urn: @image_urn, admin-username: @admin_username, vm-size: @vm_size, availset-name: @availset.name, storage-account-name: @storage_account.name, custom-data: @custom_data
  nsg_rules:~ ->
    @_nsg_rules ?=
      @nsg_rule_options
      |> obj-to-pairs
      |> map ([name, {source_address_prefix, source_port_range, destination_address_prefix, destination_port_range, priority, access, direction}])~>
        new NsgRule resource-group: @rg.name, name: name, nsg-name: @nsg.name, source-address-prefix: source_address_prefix, source-port-range: source_port_range, destination-address-prefix: destination_address_prefix, destination-port-range: destination_port_range, priority: priority, access: access, direction: direction
  probes:~ ->
    @_probes ?=
      @probe_options
      |> obj-to-pairs
      |> map ([name, {protocol, port, path, interval, count}])~>
        new Probe resource-group: @rg.name, name: name, lb-name: @lb.name, protocol: protocol, port: port, path: path, interval: interval, count: count
  lb_rules:~ ->
    @_lb_rules ?=
      @lb_rule_options
      |> obj-to-pairs
      |> map ([name, {protocol, frontend_port, backend_port, probe_name}])~>
        new LbRule resource-group: @rg.name, name: name, lb-name: @lb.name, protocol: protocol, frontend-port: frontend_port, backend-port: backend_port, probe-name: probe_name, frontend-ip-name: @lb_frontend_ip.name, backend-address-pool: @address_pool.name
  disks:~ ->
    @_disks ?=
      [0 til @size]
      |> map (index)~>
        new Disk resource-group: @rg.name, name: "#{@name}-#index", vm-name: @vms.(index).name, size-in-gb: @disk_size, host-caching: @disk_caching, storage-account-name: @storage_account.name, storage-account-container-name: @disk_container_name, lun: 0
  azure_resources:~ ->
    [
      @nsg
      @subnet
      @public_ip
      @lb
      @lb_frontend_ip
      @address_pool
      @nics
      @storage_account
      @availset
      @vms
      @nsg_rules
      @probes
      @lb_rules
      (if @has_disk then @disks else [])
    ] |> flatten
  create_cloud_config: (cb)->
    err, template <~ fs.read-file @cloud_config_template_path, \utf-8
    err, content <~ @process_template template
    err <~ fs.write-file "#{@tmp_dir}/#{@name}-cluster-cloud-config.yml", content
    cb err
  create_if_doesnt_exist: (cb)->
    <~ @create_cloud_config
    err, res <~ async.series (
      @azure_resources |> map (azure_resource)~>
        (next)~>
          err, res <~ azure_resource.create_if_doesnt_exist
          console.log (err or res)
          next err, res
    )
    cb err

