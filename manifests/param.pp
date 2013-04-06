define git::param(
    $user,
    $key,
    $value,
    $global = true,
){

    Class['git'] -> Git::Param[$name]

    if $global {
        exec{ $name:
            command => "/bin/su ${user} -c 'git config --global ${key} \"${value}\"'",
            unless  => "/bin/su ${user} -c 'git config --global ${key}'|/bin/grep '${value}'",
        }
    } else {
        exec{ $name:
            command => "/bin/su ${user} -c 'git config ${key} \"${value}\"'",
            unless  => "/bin/su ${user} -c 'git config ${key}'|/bin/grep '${value}'",
        }
    }
}
