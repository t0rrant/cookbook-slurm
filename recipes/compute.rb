class ::Chef::Recipe
  include ::Slurm
end

# ###########################################################################################
# package installation
# ###########################################################################################
node['slurm']['compute']['packages'].each(&method(:package))

# ###########################################################################################
# package and service configuration
# ###########################################################################################

# # fstab for controller
munge_dir = ::File.dirname(node['slurm']['munge']['key'])
apps_dir = node['slurm']['apps_dir']
homes_dir = node['slurm']['homes_dir']
control_machine = node['slurm']['control_machine']
nfs_apps_server = node['slurm']['nfs_apps_server']
nfs_homes_server = node['slurm']['nfs_homes_server']
origin = node['slurm']['controller'].nil? ? control_machine : nfs_apps_server

[munge_dir, apps_dir].each do |dir|
  mount dir.to_s do
    device "#{origin}:#{dir}"
    fstype 'nfs'
    options 'rw,sync,hard,intr'
    dump 0
    pass 0
    action
    only_if { origin != node['hostname'] }
  end
end

origin = node['slurm']['controller'].nil? ? control_machine : nfs_homes_server

mount homes_dir.to_s do
  device "#{origin}:#{homes_dir}"
  fstype 'nfs'
  options 'rw,sync,hard,intr'
  dump 0
  pass 0
  action [:enable, :mount]
  only_if { origin != node['hostname'] }
end
# ###########################################################################################
# service activation
# ###########################################################################################

file "#{node['slurm']['common']['conf_dir']}/cgroup_allowed_devices_file.conf" do
  content ''
end

service 'Slurm Client Service' do
  service_name 'slurmd'
  action :start
end
