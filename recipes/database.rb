class ::Chef::Recipe
  include ::Slurm
end

# ###########################################################################################
# secret definition
# ###########################################################################################
db_root_pass = node.normal['mariadb']['server_root_password'] = get_password 'db', 'mysqlroot'

# ###########################################################################################
# package installation
# ###########################################################################################

# make sure packages are up to date before continuing
if platform_family?('debian')
  apt_update 'update before repo' do
    action :update
  end
end

proxy = (node['proxy'].nil? || node['proxy']['http'].nil?) ? false : node['proxy']['http'] # see https://github.com/chef/cookstyle/issues/43
mariadb_repository 'mariadb repo' do
  version node['mysql']['version']
  apt_repository node['mysql']['apt_repository']
  apt_key_proxy proxy
end

# this should be redundant but I seems neither mariadb_repository or package resource call apt_update
if platform_family?('debian')
  apt_update 'update after repo' do
    action :update
  end
end

mariadb_client_install 'MariaDB Client install' do
  version node['mysql']['version']
  setup_repo false
end

mariadb_server_install 'MariaDB Server install' do
  version node['mysql']['version']
  mycnf_file 'database/50-server_conf.erb'
  setup_repo false
  password db_root_pass
  action [:install, :create]
end

# ###########################################################################################
# package and service configuration
# ###########################################################################################
mariadb_server_configuration 'Maintain Server config' do
  mysqld_bind_address node['mysql']['bind_address']
  action :modify
  notifies :restart, 'service[mariadb]', :immediately
end

mariadb_database 'Create accounting database' do
  database_name 'slurm_acct_db'
  password db_root_pass
  action :create
end

mariadb_database 'Create jobs database' do
  database_name 'slurm_job_db'
  password db_root_pass
  action :create
end

# apparently we can't use the get_password method within the mariadb_user resource, go figure =(
bd_user_pass = get_password 'db', node['mysql']['user']['slurm']
%w(slurm_acct_db slurm_job_db).each do |db_name|
  mariadb_user "Create Slurm user and grant permissions for #{db_name}" do
    username node['mysql']['user']['slurm']
    host '%'
    password bd_user_pass
    privileges [:all]
    database_name db_name
    ctrl_password db_root_pass
    action [:create, :grant]
  end
end

find_resource(:service, 'mariadb') do
  extend MariaDBCookbook::Helpers
  service_name lazy { platform_service_name }
  supports restart: true, status: true
  action [:enable, :start]
end
