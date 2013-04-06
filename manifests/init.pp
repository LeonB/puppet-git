class git(
	$package_name  = params_lookup( 'package_name' ),
	$enabled       = params_lookup( 'enabled' )
  ) inherits git::params {

  	$ensure = $enabled ? {
  		true => present,
  		false => absent
  	}

	include git::package, git::config
}
