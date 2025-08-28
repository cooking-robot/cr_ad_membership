#
# Cookbook:: cr_ad_join
# Recipe:: default
#
# Copyright:: 2025, Remi BONNET, GPL v3.

if node['hostname'].length > 15
  log 'Maximum hostname limit reached' do
    level :error
    message 'The machine hostname have more than 15 characters. It wil be truncate on the Active Directory and can overlap another machine.'
  end
  raise 'Maximum hostname length reached'
end

if node['ad_membership']['domain']
  ad_membership node['ad_membership']['domain'] do
    domain_name node['ad_membership']['domain']
    domain_user node['ad_membership']['user']
    domain_password node['ad_membership']['password']
    ou_path node['ad_membership']['ou']
    workgroup_name node['ad_membership']['workgroup']
  end
end

if platform_family?('debian')

  inifile 'ignore GPO' do
    path '/etc/sssd/sssd.conf'
    section "domain/#{node['ad_membership']['domain']}"
    values ({
        ad_gpo_ignore_unreadable: 'True',
        ad_gpo_map_interactive: '+mdm',
        use_fully_qualified_names: 'False'
      })
  end

  replace_or_add 'nsswitch.conf' do
    path '/etc/nsswitch.conf'
    pattern '^hosts:'
    line 'hosts:          files dns mdns4_minimal [NOTFOUND=return]'
    sensitive false
  end

  replace_or_add 'pam.d/common-account' do
    path '/etc/pam.d/common-account'
    pattern 'session\W+required\W+pam_mkhomedir.so'
    line 'session    required   pam_mkhomedir.so skel=/etc/skel/ umask=0022'
    sensitive false
  end

  directory '/etc/krb5.conf.d' do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end

  cookbook_file '/etc/krb5.conf.d/10-domain' do
    source 'krb5.conf'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
  end
  
  cookbook_file '/etc/mdm.conf' do
    source 'mdm.conf'
    only_if 'test -e /etc/mdm.conf'
    action :create
  end
  
  cookbook_file '/etc/lightdm/lightdm.conf.d/50-show-manual-login.conf' do
    source 'lightdm.conf'
    owner 'root'
    group 'root'
    mode '0644'
    only_if 'test -e /etc/lightdm/'
    action :create
  end

  service 'sssd' do
    action [:enable, :start]
  end

  include_recipe '::cifs'

  node['ad_membership']['hide_users'].each do |user|
    inifile "Hide user #{user}" do
      only_if 'test -e /var/lib/AccountsService'
      path "/var/lib/AccountsService/users/#{user}"
      section 'User'
      values ({SystemAccount: 'true'})
    end
  end
end
