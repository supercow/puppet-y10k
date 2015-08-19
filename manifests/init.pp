# Class: y10k
# ===========================
#
# This class manages the base installation and configuration of y10k.
#
# It is assumed that you already have a repository configured with a package
# called `y10k`.
#
# Parameters
# ----------
#
# None
#
#
# Examples
# --------
#
# @example
#   include y10k
#
# Authors
# -------
#
# James Sweeny <james@sweeny.io>
#
class y10k(
  $config_file = '/etc/y10k.conf',
  $prefix      = '/var/www/yum',
) {

  # Pre-requisites
  ensure_packages(['yum-utils','createrepo'])

  package { 'y10k':
    ensure => 'present',
  }

  concat { $config_file:
    ensure => present,
  }

  concat::fragment { 'y10k base config':
    target  => $config_file,
    content => template('y10k/global.erb'),
    order   => '000'
  }
}
