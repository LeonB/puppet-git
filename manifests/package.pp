class git::package {

  package  { $git::package_name:
    ensure  => $git::ensure,
    require => Apt::Ppa['ppa:git-core/ppa'],
  }

  # Git stable releases from launchpad
  apt::ppa { 'ppa:git-core/ppa': }
}
