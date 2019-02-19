if os.debian?
  describe package('slurmdbd') do
    it { should be_installed }
  end

  describe service('slurmdbd') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end
