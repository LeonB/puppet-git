# Class: git::params
#
# This class defines default parameters used by the main module class git
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to git class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class git::params {

  ### Application related parameters

  $package_name = $::operatingsystem ? {
    default => ['git', 'git-extras']
  }

  $enabled = true

}
