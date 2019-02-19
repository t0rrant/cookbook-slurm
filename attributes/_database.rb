default['mysql']['bind_address'] = '0.0.0.0'
# matching our cookbook and mariadb cookbook naming, in the future we may rename our attributes
# to reflect mariadb naming structure
default['mysql']['port'] = normal['mariadb']['mysqld']['port'] = '3306'
default['mysql']['version'] = '10.1'
default['mysql']['character-set-server'] = 'utf8'
default['mysql']['collation-server'] = 'utf8_general_ci'
default['mysql']['user']['slurm'] = 'slurm'
default['mysql']['apt_repository'] = 'http://mirrors.up.pt/pub/mariadb/repo'
