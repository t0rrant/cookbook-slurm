if !node['shifter'].nil? && node['shifter'].eql?(true)
  template 'Shifter plugin for SLURM' do
    path node['slurm']['server']['plugstack_dir'] + '/shifter.conf'
    source 'shifter_plugstack_conf.erb'
    mode '644'
    only_if 'which shifter'
  end
end
