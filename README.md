# cr_ad_membership

Ad Membership. A cookbook for joining and leaving Active Directory multiplatform.

This project is a part of Cooking Robot group.

## How to use

This cookbook provide a default recipe that join AD and a custom resource if you whan a better control of AD junction.

### The default recipe

The default recipe join an Active directory with the following attributes:

* cr_ad_membership.ou : Organization unit to join
* cr_ad_membership.user : Admin username. You might use the vault to keep instead of attributes credentials.
* cr_ad_membership.password : Admin password. You might use the vault to keep instead of attributes credentials.
* cr_ad_membership.hide_users : Array of username you don't want to appears on the login screen (like local admins).
* cr_ad_membership.domain : Domain name (FQDN) to join.

The default recipe also configure CIFS tools and Kerberos to use SSO on apps and shares on Linux.

#### Vault Items
You may use Chef Vault for storing identifiants to join AD. The vault item used bu recipe is passwords:ads. The item must have two keys : user and Password.

## The resource

This cookbook provide a resource to join or leave AD :

```ruby
ad_membership node['ad_membership']['domain'] do
    domain_name node['ad_membership']['domain']
    domain_user node['ad_membership']['user']
    domain_password node['ad_membership']['password']
    ou_path node['ad_membership']['ou']
    workgroup_name node['ad_membership']['workgroup']
end
```

Action can be `:join` to join AD and `:leave`.
