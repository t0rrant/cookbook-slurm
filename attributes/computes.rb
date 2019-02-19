default['slurm']['conf']['conf']['ControlMachine'] = node['slurm']['control_machine']
default['slurm']['conf']['conf']['AuthType'] = 'auth/munge'
default['slurm']['conf']['conf']['CacheGroups'] = '0'
default['slurm']['conf']['conf']['CryptoType'] = 'crypto/munge'
default['slurm']['conf']['conf']['JobCheckpointDir'] = '/var/lib/slurm-llnl/checkpoint'
default['slurm']['conf']['conf']['KillOnBadExit'] = '01'
default['slurm']['conf']['conf']['MpiDefault'] = 'none'
default['slurm']['conf']['conf']['MailProg'] = '/usr/bin/mail'
default['slurm']['conf']['conf']['PrivateData'] = 'cloud,usage,users,accounts'
default['slurm']['conf']['conf']['ProctrackType'] = 'proctrack/cgroup'
default['slurm']['conf']['conf']['PrologFlags'] = 'Alloc,Contain' # removed x11
default['slurm']['conf']['conf']['PropagateResourceLimits'] = 'NONE'
default['slurm']['conf']['conf']['RebootProgram'] = '/sbin/reboot'
default['slurm']['conf']['conf']['ReturnToService'] = '1'
default['slurm']['conf']['conf']['SlurmctldPidFile'] = '/var/run/slurm-llnl/slurmctld.pid'
default['slurm']['conf']['conf']['SlurmctldPort'] = '6817'
default['slurm']['conf']['conf']['SlurmdPidFile'] = '/var/run/slurm-llnl/slurmd.pid'
default['slurm']['conf']['conf']['SlurmdPort'] = '6818'
default['slurm']['conf']['conf']['SlurmdSpoolDir'] = '/var/lib/slurm-llnl/slurmd'
default['slurm']['conf']['conf']['SlurmUser'] = node['slurm']['user']
default['slurm']['conf']['conf']['StateSaveLocation'] = '/var/lib/slurm-llnl/slurmctld'
default['slurm']['conf']['conf']['SwitchType'] = 'switch/none'
default['slurm']['conf']['conf']['TaskPlugin'] = 'task/cgroup'

# TIMERS
default['slurm']['conf']['conf']['InactiveLimit'] = '0'
default['slurm']['conf']['conf']['KillWait'] = '30'
default['slurm']['conf']['conf']['MinJobAge'] = '300'
default['slurm']['conf']['conf']['SlurmctldTimeout'] = '120'
default['slurm']['conf']['conf']['SlurmdTimeout'] = '300'
default['slurm']['conf']['conf']['Waittime'] = '0'

# SCHEDULING
default['slurm']['conf']['conf']['FastSchedule'] = '1'
default['slurm']['conf']['conf']['SchedulerType'] = 'sched/backfill'
default['slurm']['conf']['conf']['SelectType'] = 'select/cons_res'
default['slurm']['conf']['conf']['SelectTypeParameters'] = 'CR_Core_Memory'

# PREEMPT POLICIES
default['slurm']['conf']['conf']['PreemptType'] = 'preempt/partition_prio'
default['slurm']['conf']['conf']['PreemptMode'] = 'REQUEUE'

# LOGGING AND ACCOUNTING
default['slurm']['conf']['conf']['AccountingStorageEnforce'] = 'associations,limits,qos,safe'
default['slurm']['conf']['conf']['AccountingStorageType'] = 'accounting_storage/slurmdbd'
default['slurm']['conf']['conf']['AccountingStoreJobComment'] = 'YES'
default['slurm']['conf']['conf']['AccountingStorageHost'] = node['slurm']['accounting_machine']
default['slurm']['conf']['conf']['ClusterName'] = node['slurm']['cluster'].nil? || node['slurm']['cluster']['name'].nil? ? 'slurm-test' : node['slurm']['cluster']['name']
default['slurm']['conf']['conf']['JobAcctGatherFrequency'] = '30'
default['slurm']['conf']['conf']['JobAcctGatherType'] = 'jobacct_gather/linux'
default['slurm']['conf']['conf']['SlurmctldDebug'] = '3'
default['slurm']['conf']['conf']['SlurmctldLogFile'] = '/var/log/slurm-llnl/slurmctld.log'
default['slurm']['conf']['conf']['SlurmdDebug'] = '3'
default['slurm']['conf']['conf']['SlurmdLogFile'] = '/var/log/slurm-llnl/slurmd.log'
default['slurm']['conf']['conf']['SlurmSchedLogFile'] = '/var/log/slurm-llnl/slurmschd.log'
default['slurm']['conf']['conf']['SlurmSchedLogLevel'] = '3'
