execute 'Systemd Daemon Reload' do
  command 'systemctl daemon-reload'
  action :nothing
end
