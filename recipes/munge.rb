class ::Chef::Recipe
  include ::Slurm
end

# ###########################################################################################
# package and service configuration
# ###########################################################################################

'epel-release'.method(:package) if node['platform_family'] == 'rhel'

package 'munge'

template 'MUNGE default environment' do
  path node['slurm']['munge']['env_file']
  source 'munge_default.erb'
end

munge_key_64 = get_password 'token', 'munge'
file node['slurm']['munge']['key'] do
  content lazy { ::Base64.decode64(munge_key_64) }
  sensitive true
  notifies_before :stop, 'service[Munge Authentication Service]'
  notifies_immediately :start, 'service[Munge Authentication Service]'
end

# ###########################################################################################
# service activation
# ###########################################################################################
service 'Munge Authentication Service' do
  service_name 'munge'
  retries 3
  retry_delay 2
  sensitive true
  action :nothing
end
