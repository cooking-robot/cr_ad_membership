# To learn more about Custom Resources, see https://docs.chef.io/custom_resources/
provides :ad_membership

property :domain_name, String, required: true, name_property: true
property :domain_user, String, desired_state: false
property :domain_password, String, desired_state: false
property :ou_path, String, desired_state: false
property :reboot, Symbol, desired_state: false
property :workgroup_name, String, desired_state: false

load_current_value do |new_resource|
  # For sssctl domain-status
  if platform_family?('debian')
    begin
      shell_out!("sssctl domain-status #{new_resource.domain_name}")
      domain_name new_resource.domain_name
    rescue
      current_value_does_not_exist!
    end
  else
    current_value_does_not_exist!
  end
end

action :join do
  converge_if_changed do
    if platform_family?('windows')
      windows_ad_join new_resource.domain_name do
        domain_user new_resource.domain_user
        domain_password new_resource.domain_password
        if new_resource.workgroup_name
          workgroup_name new_resource.workgroup_name
        end
        if new_resource.ou_path
          ou_path new_resource.ou_path
        end
        action :join
      end
    elsif platform_family?('debian')
      package %w(sssd sssd-tools adcli winbind libpam-winbind libnss-winbind krb5-config krb5-user realmd)

      # Ensure FQDN is valid for this domain
      replace_or_add 'Hostname FQDN' do
        path '/etc/hosts'
        pattern "\W#{node['hostname']}(|\W.*)$"
        line "127.0.1.1 #{node['hostname']}.#{new_resource.domain_name} #{node['hostname']}"
      end
      execute "REALM JOIN #{new_resource.domain_name}" do
        command "realm join #{new_resource.domain_name} --client-software=sssd --server-software=active-directory --user=#{new_resource.domain_user}"
        input new_resource.domain_password
        notifies :request_reboot, 'reboot[ADJOIN]'
      end
      reboot 'ADJOIN' do
        action :nothing
        reason 'Joining AD'
      end
      
    end
  end
end

action :leave do
  if platform_family?('windows')
    windows_ad_join new_resource.domain_name do
      action :leave
    end
  else
    execute "REALM LEAVE #{new_resource.domain_name}" do
      command "realm leave #{new_resource.domain_name}"
    end
  end
end
