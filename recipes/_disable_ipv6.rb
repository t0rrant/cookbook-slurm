keys = %w(net.ipv6.conf.all.disable_ipv6 net.ipv6.conf.default.disable_ipv6)
keys.append('net.ipv6.conf.lo.disable_ipv6') if node['platform_family'] == 'debian'

keys.each do |key|
  sysctl key do
    value 1
    action :apply
  end
end
