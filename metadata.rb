name 'cr_ad_membership'
maintainer 'The Authors'
maintainer_email 'you@example.com'
license 'All Rights Reserved'
description 'Installs/Configures cr_ad_join'
version '0.1.0'
chef_version '>= 16.0'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
issues_url 'https://github.com/Cooking-Rebot/cr_ad_membership/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
source_url 'https://github.com/Cooking-Rebot/cr_ad_membership'

depends 'line'
depends 'cr_inifile'

supports 'debian'
supports 'windows'
supports 'ubuntu'

gem 'chef-vault'
