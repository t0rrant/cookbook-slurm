if os.debian?
  %w(mailutils
     slurm-wlm
     slurm-wlm-basic-plugins
     sview
     nfs-kernel-server
     nfs-common).each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end

  describe user('slurm') do
    it { should exist }
  end

  describe file('/etc/slurm-llnl/slurm.conf') do
    it { should exist }
  end

  describe service('slurmctld') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end
