# ###########################################################################################
# package installation
# ###########################################################################################
node['slurm']['common']['packages'].each(&method(:package))
