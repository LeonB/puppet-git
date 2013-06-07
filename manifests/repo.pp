# = Define a git repository as a resource
#
# == Parameters:
#
# $source::     The URI to the source of the repository
#
# $path::       The path where the repository should be cloned to, fully qualified paths are recommended, and the $owner needs write permissions.
#
# $branch::     The branch to be checked out
#
# $git_tag::    The tag to be checked out
#
# $owner::      The user who should own the repository
#
# $update::     If this is true, puppet will revert local changes and pull remote changes when it runs.
#
# $bare::       If this is true, git will create a bare repository

define git::repo(
    $path,
    $source   = false,
    $branch   = undef,
    $git_tag  = undef,
    $owner    = 'root',
    $group    = 'root',
    $mode     = undef,
    $update   = false,
    $bare     = false
){

    Class['git'] -> Git::Repo[$name]

    validate_bool($bare, $update)

    if $branch {
        $real_branch = $branch
    } else {
        $real_branch = 'master'
    }

    if $source {
        $init_cmd = "/usr/bin/git clone -b ${real_branch} ${source} ${path} --recursive"
    } else {
        if $bare {
            $init_cmd = "/usr/bin/git init --bare ${path}"
        } else {
            $init_cmd = "/usr/bin/git init ${path}"
        }
    }

    $creates = $bare ? {
        true    => "${path}/objects",
        default => "${path}/.git",
    }


    if !defined(File[$path]) {
        file { $path:
            ensure  => directory,
            owner   => $owner,
            group   => $group,
            mode    => $mode,
            recurse => true,
        }
    }

    exec { "git_repo_${name}":
        command => $init_cmd,
        user    => $owner,
        creates => $creates,
        timeout => 600,
        require => File[$path],
    }

    # I think tagging works, but it's possible setting a tag and a branch will just fight.
    # It should change branches too...
    if $git_tag {
        exec { "git_${name}_co_tag":
            user    => $owner,
            cwd     => $path,
            command => "/usr/bin/git checkout ${git_tag}",
            unless  => "/usr/bin/git describe --tag|/bin/grep -P '${git_tag}'",
            require => Exec["git_repo_${name}"],
        }
    } else {
        exec { "git_${name}_co_branch":
            user    => $owner,
            cwd     => $path,
            command => "/usr/bin/git checkout ${branch}",
            unless  => "/usr/bin/git branch|/bin/grep -P '\\* ${branch}'",
            require => Exec["git_repo_${name}"],
        }
        if $update {
            exec { "git_${name}_pull":
                user    => $owner,
                cwd     => $path,
                command => "/usr/bin/git reset --hard HEAD && /usr/bin/git pull origin ${branch}",
                unless  => '/usr/bin/git diff origin --no-color --exit-code',
                require => Exec["git_repo_${name}"],
            }
        }
    }
}
