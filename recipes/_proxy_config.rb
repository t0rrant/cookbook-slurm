if !node['proxy'].nil? && !node['proxy']['http'].nil?
  # workaround for some apt commands that may be executed directly during recipe execution but outside of chef's env
  case node['platform_family']
  when 'debian'
    file '/etc/apt/apt.conf' do
      owner 'root'
      group'root'
      mode '755'
      content "Acquire::http::proxy #{ node['proxy']['http']};
Acquire::ftp::proxy #{ node['proxy']['http']};
Acquire::https::proxy #{ node['proxy']['http']};"
    end
  end

  # proxy config for bash
  file '/etc/profile.d/proxy.sh' do
    owner 'root'
    group'root'
    mode '755'
    content "export http_proxy=#{ node['proxy']['http']}
export https_proxy=#{ node['proxy']['http']}
export ftp_proxy=#{ node['proxy']['http']}
export all_proxy=#{ node['proxy']['http']}"
  end

  # proxy config for the whole environment (as seen by InSpec)
  file '/etc/environment' do
    owner 'root'
    group'root'
    mode '755'
    content "export http_proxy=#{ node['proxy']['http']}
export https_proxy=#{ node['proxy']['http']}
export ftp_proxy=#{ node['proxy']['http']}
export all_proxy=#{ node['proxy']['http']}"
  end
end
