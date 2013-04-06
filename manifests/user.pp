# = Define a git user resource
#
# At the moment this:
# - Sets the git global user.name
# - Sets the git global user.email
#
# == Parameters:
#
# $user_name::    The proper name for the user
# $user_email::   The email address for the user
#
# == Usage:
#
# git::user{'somebody':
#   user_name   => 'Mr. Some Body',
#   user_email  => 's.body@example.org',
# }

define git::user(
  $user_name  = false,
  $user_email = false
){

    $git_name = $user_name ? {
        false   => "${name} on ${::fqdn}",
        default => $user_name,
    }

    $git_email = $user_email ? {
        false   => "${name}@${::fqdn}",
        default => $user_email,
    }

    git::param { "${name}_global_git_name":
        user  => $name,
        key   => 'user.name',
        value => $git_name,
    }

    git::param { "${name}_global_git_email":
        user  => $name,
        key   => 'user.email',
        value => $git_email,
    }

}
