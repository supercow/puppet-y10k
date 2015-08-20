# y10k

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)

## Overview

Module to manage installation and configuration of the [y10k]('http://cavaliercoder.github.io/y10k/')
package repository syncronization tool.

## Module Description

This module manages **almost** everything you need to get up and running with y10k.

Not included:

* y10k packages or a repository to host them
* A webserver to serve your mirror from

Included:

* Non-conflicting installation of pre-requisite packages using ensure\_packages()
* Configurable, optional cron jobs to update packages
* Installation of y10k from an OS configured yum repository
* Configuration of which repositories to mirror and most available settings

## Usage

Example usage:

This example will create a mirror of the CentOS 7 64-bit base repository. A
cron job will be created to update every Sunday at 4AM.

```puppet
include y10k

y10k::repo { 'centos-7-x86_64-base':
  mirrorlist => 'http://mirrorlist.centos.org/?release=7&arch=x86_64&repo=os',
  localpath  => 'centos/7/os/x86_64',
  arch       => 'x86_64',
  interval   => { 'hour' => 4, 'minute' => 0, 'weekday' => 0 },
}
```
