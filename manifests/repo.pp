# Define: y10k::repo
# ===========================
#
# Manage configuration of individual repositories to be synchronized
#
# Parameters
# ----------
#
# *name*
#   **namevar**
#   The name of the repository and not much else.
#
# *mirrorlist*
#   Location of a list of mirrors to copy from
#
# *localpath*
#   The path within the base directory to sync this repo to
#
# *arch*
#   The repository architecture to sync
#
# *deleteremoved*
#   Clean up packages that no longer exist upstream (default: true)
#
# *interval*
#   Cron parameters for when y10k should run
#
# Examples
# --------
#
# @example
#   # Mirror the CentOS 7 64-bit repository every Sunday at 4AM
#   y10k::repo { 'centos-7-x86_64-base':
#     mirrorlist => 'http://mirrorlist.centos.org/?release=7&arch=x86_64&repo=os',
#     localpath  => 'centos/7/os/x86_64',
#     arch       => 'x86_64',
#     interval   => { 'hour' => 4, 'minute' => 0, 'weekday' => 0 },
#   }
#
# Authors
# -------
#
# James Sweeny <james@sweeny.io>
#
define y10k::repo(
  $localpath,
  $arch,
  $deleteremoved,
  $interval = {},
  $mirrorlist = 'UNSET',
  $baseurl    = 'UNSET',
) {

  contain 'y10k'

  if ($baseurl == 'UNSET' and $mirrorlist == 'UNSET') {
    fail("Must set either baseurl or mirror list in Y10k::Repo['${name}']")
  }

  concat::fragment { "y10k repo ${name}":
    target  => $::y10k::config_file,
    order   => '010',
    content => template('y10k/repo.erb'),
  }

  if $interval != {} {
    create_resources('cron',{ "${name} repo sync" => $interval })
  }

}
