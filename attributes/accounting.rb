default['slurm']['accounting']['conf_file'] = node['slurm']['common']['conf_dir'] + '/slurmdbd.conf'
default['slurm']['accounting']['env_file'] = '/etc/default/slurmdbd'
default['slurm']['accounting']['bin_file'] = '/usr/sbin/slurmdbd'
default['slurm']['accounting']['pid_file'] = '/var/run/slurm-llnl/slurmdbd.pid'
default['slurm']['accounting']['systemd_file'] = '/lib/systemd/system/slurmdbd.service'
default['slurm']['accounting']['debug'] = '3' # valid from 0-7

default['slurm']['accounting']['conf'] = {
  AuthType: 'auth/munge',
  AuthInfo: node['slurm']['munge']['auth_socket'],
  DbdHost: node['slurm']['accounting_machine'],
  DebugLevel: node['slurm']['accounting']['debug'],
  LogFile: '/var/log/slurm-llnl/slurmdbd.log', # default is syslog
  MessageTimeout: '10',
  PidFile: node['slurm']['accounting']['pid_file'], # The default value is "/var/run/slurmdbd.pid"
  SlurmUser: node['mysql']['user']['slurm'], # default is root, please specify another one
  StorageHost: node['slurm']['storage_machine'],
  StorageLoc: 'slurm_acct_db',
  StoragePort: node['mysql']['port'],
  StorageType: 'accounting_storage/mysql',
  StorageUser: node['mysql']['user']['slurm'],
}
