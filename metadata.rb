name 'cr_ad_membership'
maintainer 'Remi BONNET'
maintainer_email 'prog.bontiv@gmail.com'
license 'GPL-3.0'
description 'Join or leave active directory (multiplatform)'
version '0.1.1'
chef_version '>= 16.0'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
issues_url 'https://github.com/cooking-robot/cr_ad_membership/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
source_url 'https://github.com/cooking-robot/cr_ad_membership'

depends 'line'
depends 'cr_inifile'

supports 'debian'
supports 'windows'
supports 'ubuntu'

gem 'chef-vault'
