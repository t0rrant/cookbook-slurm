if os.debian?
  describe apt('http://mirrors.up.pt/pub/mariadb/repo/10.1/debian') do
    it { should exist }
    it { should be_enabled }
  end

  describe package('mariadb-client-10.1') do
    it { should be_installed }
  end

  describe package('mariadb-server-10.1') do
    it { should be_installed }
  end

  describe service('mariadb') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end
