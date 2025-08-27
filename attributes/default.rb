default['ad_membership']['domain'] = nil

default['ad_membership']['ou'] = nil
default['ad_membership']['workgroup'] = nil
default['ad_membership']['hide_users'] = ['temp']

if ChefVault::Item.vault?('passwords', 'ads')
  admin = ChefVault::Item.load('passwords', 'ads')
  default['ad_membership']['user'] = admin['user']
  default['ad_membership']['password'] = admin['password']
else
  default['ad_membership']['user'] = nil
  default['ad_membership']['password'] = nil
end