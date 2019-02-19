class ::Chef::Recipe
  include ::Slurm
end

include_recipe 'slurm-cluster::_systemd_daemon_reload'

# ###########################################################################################
# package installation
# ###########################################################################################
node['slurm']['accounting']['packages'].each(&method(:package))

# ###########################################################################################
# package and service configuration
# ###########################################################################################
node.default['slurm']['accounting']['conf']['StoragePass'] = get_password 'db', node['mysql']['user']['slurm']

template 'Slurm Accounting config' do
  path node['slurm']['accounting']['conf_file']
  source 'slurmdbd_conf.erb'
  owner node['slurm']['user']
  group node['slurm']['group']
  mode '600'
  sensitive true
  notifies_before :stop, 'service[Slurm Accounting Service]'
end

template 'Slurm Accounting systemd unit file' do
  path node['slurm']['accounting']['systemd_file']
  source 'slurmdbd_service.erb'
  notifies_immediately :run, 'execute[Systemd Daemon Reload]'
  notifies_immediately :start, 'service[Slurm Accounting Service]'
end

# ###########################################################################################
# service activation
# ###########################################################################################

service 'Slurm Accounting Service' do
  service_name 'slurmdbd'
  action :nothing
end
