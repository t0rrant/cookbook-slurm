%w(https http all ftp).each do |vars|
  describe os_env(vars + '_proxy') do
    its('content') { should eq 'http://proxy.change.me:3128' }
  end
end
