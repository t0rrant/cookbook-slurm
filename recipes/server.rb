class ::Chef::Recipe
  include ::Slurm
end

include_recipe 'slurm::_systemd_daemon_reload'

# ###########################################################################################
# package installation
# ###########################################################################################
node['slurm']['server']['packages'].each(&method(:package))

# ###########################################################################################
# package and service configuration
# ###########################################################################################
# TODO: include_recipe 'postfix::default'
munge_dir = ::File.dirname(node['slurm']['munge']['key'])
apps_dir = node['slurm']['apps_dir']
homes_dir = node['slurm']['homes_dir']

# TODO: redesign node generation from attributes
node_def = ''
partition_def = ''
cluster_name = node['slurm']['cluster'].nil? || node['slurm']['cluster']['name'].nil? ? 'slurm-test' : node['slurm']['cluster']['name']

%w(small medium large).each do |type|
  next if node['slurm']['conf']['nodes'].nil? || node['slurm']['conf']['nodes'][type].nil?
  count = node['slurm']['conf']['nodes'][type]['count']
  cpus = node['slurm']['conf']['nodes'][type]['properties']['cpus']
  mem = node['slurm']['conf']['nodes'][type]['properties']['mem']
  sockets = node['slurm']['conf']['nodes'][type]['properties']['sockets']
  cores_per_socket = node['slurm']['conf']['nodes'][type]['properties']['cores_per_socket']
  threads_per_core = node['slurm']['conf']['nodes'][type]['properties']['threads_per_core']
  weight = node['slurm']['conf']['nodes'][type]['properties']['weight']
  node_def << format("NodeName=#{cluster_name}-#{type}-compute[1-%d] Procs=#{cpus} Sockets=#{sockets} CoresPerSocket=#{cores_per_socket} ThreadsPerCore=#{threads_per_core} RealMemory=#{mem} Weight=#{weight}\n", count)
  partition_def << format("PartitionName=#{type} Nodes=#{cluster_name}-#{type}-compute[1-%d] Default=YES MaxTime=INFINITE State=UP", count)
end

if !node_def || node['slurm']['monolith_testing']
  Chef::Log.warn 'No nodes defined or testing monolith as well'
  node_def << "NodeName=#{node['hostname']} Procs=#{node['cpu']['cores']} Sockets=#{node['cpu']['cores']} CoresPerSocket=1 ThreadsPerCore=1 RealMemory=#{node['memory']['total'][0..-3].to_i / 1024 / 2} Weight=1"
  partition_def << format("PartitionName=control Nodes=#{format('%s', node['hostname'])} Default=YES MaxTime=INFINITE State=UP")
end

template 'Slurm Server config' do
  path node['slurm']['server']['conf_file']
  source 'slurm_conf.erb'
  owner node['slurm']['user']
  group node['slurm']['group']
  mode '644'
  variables(node_def: node_def,
            partition_def: partition_def)
  notifies :start, 'service[Slurm Server Service]', :delayed
end

template 'Slurm Server systemd unit file' do
  path node['slurm']['server']['systemd_file']
  source 'slurmctld_service.erb'
  notifies :stop, 'service[Slurm Server Service]', :before
  notifies :run, 'execute[Systemd Daemon Reload]', :immediately
end

directory 'Slurm Server cgroup directory' do
  path node['slurm']['server']['cgroup_dir']
  owner node['slurm']['user']
  group node['slurm']['group']
  mode '755'
end

template 'Slurm Server cgroup config' do
  path node['slurm']['server']['cgroup_conf_file']
  source 'cgroup_conf.erb'
  owner node['slurm']['user']
  group node['slurm']['group']
  mode '644'
  notifies :restart, 'service[Slurm Server Service]', :delayed
end

directory 'Slurm Server plugstack directory' do
  path node['slurm']['server']['plugstack_dir']
  owner node['slurm']['user']
  group node['slurm']['group']
  mode '755'
end

template 'Slurm Server plugstack config' do
  path node['slurm']['server']['plugstack_conf_file']
  source 'plugstack_conf.erb'
  owner node['slurm']['user']
  group node['slurm']['group']
  mode '644'
  notifies :restart, 'service[Slurm Server Service]', :delayed
end

execute "add cluster #{cluster_name} to accounting" do
  command "/usr/bin/sacctmgr -i add cluster #{cluster_name}"
  action :run
  not_if "/usr/bin/sacctmgr -n list cluster #{cluster_name} | grep #{cluster_name}"
  notifies :start, 'service[Slurm Server Service]', :delayed
end

# setup NFS
# nfs tweak
# /etc/sysconfig/nfs => RPCNFSDCOUNT=256

# nfs exports config
template '/etc/exports' do
  source 'exports.erb'
  variables dirs: [munge_dir, apps_dir, homes_dir]
end

#     f.close()
#
#     subprocess.call(shlex.split("exportfs -a"))

# ###########################################################################################
# service activation
# ###########################################################################################

service 'Slurm Server Service' do
  service_name 'slurmctld'
  supports restart: true, reload: true, status: true
  reload_command " /etc/init.d/#{service_name} reconfig"
  restart_command "systemctl restart #{service_name}"
  status_command "systemctl status #{service_name}"
  action :start
end
