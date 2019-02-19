[![Build Status](https://travis-ci.org/ist-dsi/cookbook-slurm.svg?branch=master)](https://travis-ci.org/ist-dsi/cookbook-slurm)
[![Cookbook Version](https://img.shields.io/cookbook/v/slurm.svg)](https://supermarket.chef.io/cookbooks/slurm)

# slurm

Wrapper cookbook that can prepare a full slurm cluster, controller, compute and accounting nodes

## Requirements

Requires the following cookbooks:

 - mariadb, '~> 2.0.0'
 [1][1]

[1] until [this PR][https://github.com/sous-chefs/mariadb/pull/234] is approved or this version is released in the supermarket, we'll use [this fork][https://github.com/t0rrant/mariadb].

### Platforms

The following platforms are supported:

- Ubuntu 18.04
- Debian 9

Other Debian family distributions are assumed to work, as long as the slurm version from the package tree
is at least *17.02* due to hostname behaviour of slurmdbd.

### Chef

- Chef 14.0+

## TODO

- Support for RHEL family
- Make cgroup.conf file dynamic
- Add recipe to setup a dynamic resource allocation cluster
- Install slurm from static stable sources, i.e 17.11-latest, 18.08-latest
- Refactor and remove code that can be used as a resource instead of a recipe
- Remove static types of nodes and partitions and support static generation, maybe by passing the Hash directly 
- Review cookbook to ensure it respects wrapper cookbook support
- Complete spec files
- Require shifter cookbook

## Usage

Check the .kitchen.yml file for the run_list, this can be applied with:

```
$ kitchen converge [debian|ubuntu|all]
```

The use case for this run_list is to setup a monolith which contains all of the slurm components.

## Recipes

### slurm::_disable_ipv6

- Disable ipv6 on a Linux system.

### slurm::_systemd_daemon_reload

- Makes available forcing a `daemon-reload` on systemd, in order to refresh service unit files.
  
### slurm::accounting

- Installs and configures slurmdbd, slurms' accounting service.

### slurm::cluster

- *TODO* sets up a dynamic resource allocation cluster.

### slurm::compute

- Installs and configures slurmd, slurms' compute service.

### slurm::database

- Installs and configures a MariaDB service.

### slurm::default

- Installs packages common to all slurms' services.

### slurm::munge

- Installs and configures munge authentication service.

### slurm::plugin_shifter

- *TODO* sets up shifter plugin for slurm.
 
### slurm::server

- Installs and configures slurmctld, slurms' controller service.

This is where the common configuration file shared between `slurmctld` and `slurmd` services is generated.
Take a close look at attributes below.

## Attributes

The attributes are presented here in order of importance for assembling a whole infrastructure.

### Common

```
# ========================= Data bag configuration =========================
default['slurm']['secret']['secrets_data_bag']                 # The name of the encrypted data bag that stores openstack secrets

default['slurm']['secret']['service_passwords_data_bag']       # The name of the encrypted data bag that stores service user passwords, with
                                                               # each key in the data bag corresponding to a named Slurm service, like
                                                               # "slurmdbd", "slurmctl", "slurmd" (this may not be needed for slurm).

default['slurm']['secret']['db_passwords_data_bag']            # The name of the encrypted data bag that stores database passwords, with
                                                               # each key in the data bag corresponding to a named Slurm database, like
                                                               # "slurmdbd", "slurmctl", "slurmd"

default['slurm']['secret']['user_passwords_data_bag']          # The name of the encrypted data bag that stores general user passwords, with
                                                               # each key in the data bag corresponding to a user (this may not be needed for slurm).

# ========================= Slurm specific configuration =========================
default['slurm']['common']['conf_dir']                         # slurm configuration directory, usually '/etc/slurm-llnl'

default['slurm']['custom_template_banner']                     # String that is prepended to each slurm configuration file

default['slurm']['user']                                       # username to configure slurm as, usually 'slurm'

default['slurm']['group']                                      # group to configure slurm as, usually 'slurm'

default['proxy']['http']                                       # proxy address for use with apt, mariadb, and system environment
```
### Munge
```
default['slurm']['munge']['key']                               # munge key location

default['slurm']['munge']['env_file']                          # munge environment file, to be used by systemd

default['slurm']['munge']['auth_socket']                       # munge communication socket location
```

### Monolith
```
default['slurm']['control_machine']                            # fqdn of the machine where slurmctld is running

default['slurm']['nfs_apps_server']                            # fqdn of the machine where the apps directory is made available through nfs

default['slurm']['nfs_homes_server']                           # fqdn of the machine where the home directory is made available through nfs

default['slurm']['apps_dir']                                   # path to the apps directory

default['slurm']['homes_dir']                                  # path to the home directory

default['slurm']['monolith_testing']                           # tells the cookbook if the setup should be that of a monolith or not, usually for testing, either true or false
```

### Database
```
default['mysql']['bind_address']                               # CIDR to where the mariadb server should listen to connections, defaults to '0.0.0.0'

default['mysql']['port']                                       # port to where the mariadb server should listen to connections, defaults to '3306'

default['mysql']['version']                                    # MariaDB version lock, defaults to '10.1'

default['mysql']['character-set-server']                       # database character set, defaults to 'utf8'

default['mysql']['collation-server']                           # database collation, defaults to 'utf8_general_ci'   

default['mysql']['user']['slurm']                              # user which slurm accounting service uses to connect to the database
```

### Accounting
```
default['slurm']['accounting']['conf_file']                    # path to the slurmdbd configuration file, defaults to '/etc/slurm-llnl/slurmdbd.conf'

default['slurm']['accounting']['env_file']                     # path to the slurmdbd environment file location, defaults to '/etc/default/slurmdbd'

default['slurm']['accounting']['bin_file']                     # path to the slurmdbd binary, defaults to '/usr/sbin/slurmdbd'

default['slurm']['accounting']['pid_file']                     # path to the slurmdbd pid file, defaults to '/var/run/slurm-llnl/slurmdbd.pid'

default['slurm']['accounting']['systemd_file']                 # path to the slurmdbd systemd service unit file, defaults to '/lib/systemd/system/slurmdbd.service'

default['slurm']['accounting']['debug']                        # debug level, valid values from 0-7, defaults to '3'

default['slurm']['accounting']['conf']                         # Hash representing the slurmdbd configuration options
```

The default for `['slurm']['accounting']['conf']` is:
```
{
  AuthType: 'auth/munge',
  AuthInfo: node['slurm']['munge']['auth_socket'],
  DbdHost: node['hostname'], 
  DebugLevel: node['slurm']['accounting']['debug'],
  LogFile: '/var/log/slurm-llnl/slurmdbd.log', # default is syslog
  MessageTimeout: '10',
  PidFile: node['slurm']['accounting']['pid_file'], 
  SlurmUser: node['mysql']['user']['slurm'],
  StorageHost: node['hostname'], 
  StorageLoc: 'slurm_acct_db',
  StoragePort: node['mysql']['port'],
  StorageType: 'accounting_storage/mysql',
  StorageUser: node['mysql']['user']['slurm'],
}

```

take into account that when overriding `['slurm']['accounting']['conf']` you will override *all* of its options. 


### Server
```
default['slurm']['server']['conf_file']                        # path to the slurmctld and slurmd configuration file, defaults to '/etc/slurm-llnl/slurm.conf'

default['slurm']['server']['env_file']                         # path to the slurmctld environment file, defaults to '/etc/default/slurmctld'

default['slurm']['server']['bin_file']                         # path to the slurmctld binary file, defaults to '/usr/sbin/slurmctld'

default['slurm']['server']['pid_file']                         # path to the slurmctld pid file, defaults to '/var/run/slurm-llnl/slurmctld.pid'

default['slurm']['server']['systemd_file']                     # path to the slurmctld systemd service unit file, defaults to '/lib/systemd/system/slurmctld.service'

default['slurm']['server']['service_req']                      # name of the storage service(s) that the slurm service should depend on to start 
                                                               # this should be either empty or the name of the storage service client(s) that slurm might depend on (ceph, beegfs, lustre)
                                                               
default['slurm']['server']['cgroup_dir']                       # path to the cgroup plugin directory, defaults to '/etc/slurm-llnl/cgroup'

default['slurm']['server']['cgroup_conf_file']                 # path to the cgroup configuration file, defaults to '/etc/slurm-llnl/cgroup.conf'

default['slurm']['server']['plugstack_dir']                    # path to the slurm plugin directory, defaults to '/etc/slurm-llnl/plugstack.conf.d'

default['slurm']['server']['plugstack_conf_file']              # path to the slurm plugin configuration file, defaults to '/etc/slurm-llnl/plugstack.conf'
```


### Compute nodes

In the *computes.rb* attribute file you can see an example for the various slurm cluster settings.

For now we assume three types of partitions (and nodes):

- small
- medium
- large

representing the capacity (memory) for each group. The nodes in each group are assumed to be homogeneous. 

Each group properties can be passed via the following attributes
```
default['slurm']['conf']['nodes'][type]['count']                              
default['slurm']['conf']['nodes'][type]['properties']['cpus']               # amount of CPUs available in the node group, Integer
default['slurm']['conf']['nodes'][type]['properties']['mem']                # amount of RAM available in the node group, Megabytes
default['slurm']['conf']['nodes'][type]['properties']['sockets']            # number of sockets in node group, on private cloud systems it is usually the number of cpus
default['slurm']['conf']['nodes'][type]['properties']['cores_per_socket']   # number of cores per socket, on private cloud systems it is usually one
default['slurm']['conf']['nodes'][type]['properties']['threads_per_core']   # number of threas per core, on private cloud systems it is usually one
default['slurm']['conf']['nodes'][type]['properties']['weight']             # preference for being allocated work to, the lower the weight the highest the preference
```

At this time, this cookbook is designed to work either as a monolith (PoC) or to be deployed in a private cloud environment. 


## Data Bags

From the previous section we can see which data bags are required to exist. Each of the items must have a key with the same name as the data bag, where the secret value should be stored.
Within those databags we have to create the following items:

DataBag | Item | Keys 
--- | --- | ---  
slurm_db_passwords | mysqlroot | ---
slurm_db_passwords | node['mysql']['user']['slurm']  | ---
slurm_secrets | munge | --- 

Any of the `slurm_db_passwords` items should be text passwords, generated with your favorite tool.

The munge key should be a base64 key, based on binary data generated from running either of the following:

- `$ create-munge-key -r` on a system with munge installed (note that it will try to overwrite any existing key in /etc/munge/munge.key)
- `$ dd if=/dev/random bs=1 count=1024 > munge.key`
- `$ dd if=/dev/urandom bs=1 count=1024 > munge.key`

For more information on generating a munge key see the [munge documentation](https://github.com/dun/munge/wiki/Installation-Guide).
