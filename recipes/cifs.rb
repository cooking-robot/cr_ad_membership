if platform_family?('debian')
  package 'cifs-utils'

  cookbook_file '/etc/request-key.d/cifs.dns.conf' do
    source 'cifs.dns.conf'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
  end
  
  cookbook_file '/etc/request-key.d/cifs.idmap.conf' do
    source 'cifs.idmap.conf'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
  end

  cookbook_file '/etc/request-key.d/cifs.spnego.conf' do
    source 'cifs.spnego.conf'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
  end
end