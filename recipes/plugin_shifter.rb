if !node['shifter'].nil? && node['shifter'].eql?(true)
  node.normal['shifter']['imagegw_fqdn'] = node['slurm']['control_machine']

  shifter_install 'Install Shifter Runtime and make its binary available' do
    action :install
    imagegw_fqdn node['slurm']['control_machine']
  end

  template 'Shifter plugin for SLURM' do
    path node['slurm']['server']['plugstack_dir'] + '/shifter.conf'
    source 'shifter_plugstack_conf.erb'
    mode '644'
    only_if 'which shifter'
  end

  if node['slurm']['control_machine'] == node['fqdn']
    shifter_install_imagegw 'Install Shifter Runtime and make its binary available' do
      action :install
    end
  end
end
