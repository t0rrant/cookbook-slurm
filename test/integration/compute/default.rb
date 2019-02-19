if os.debian?
  %w(slurm-wlm
     slurm-wlm-basic-plugins
     nfs-common).each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end

  describe file('/etc/slurm-llnl/slurm.conf') do
    it { should exist }
  end

  describe service('slurmd') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end
