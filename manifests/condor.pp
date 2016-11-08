class creamce::condor inherits creamce::params {

  include creamce::blah
  require creamce::gip
  
  # ##################################################################################################
  # configure blah for Condor
  # ##################################################################################################
  
  file{"${blah_config_file}":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    content => template("creamce/blah.config.condor.erb"),
  }

  # ##################################################################################################
  # configure infoprovider for Condor
  # ##################################################################################################
  
  package { "lcg-info-dynamic-scheduler-condor":
    ensure  => present,
  }
  
  file { "/etc/lrms/scheduler.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    content => template("creamce/gip/condor-provider.conf.erb"),
    require => Package["lcg-info-dynamic-scheduler-condor"],
  }
  
  file { "$gippath/plugin/glite-info-dynamic-scheduler-wrapper":
    ensure => present,
    owner   => "${info_user}",
    group   => "${info_group}",
    mode => 0755,
    content => template("creamce/gip/glite-info-dynamic-scheduler-wrapper.erb"),
    require => File["/etc/lrms/scheduler.conf"],
    notify  => Class[Bdii::Service],
  }
  
  #
  # Todo verify content
  #
  file { "$gippath/plugin/glite-info-dynamic-ce":
    ensure => present,
    owner   => "${info_user}",
    group   => "${info_group}",
    mode => 0755,
    content => '#!/bin/sh\n/usr/libexec/glite-info-dynamic-condor /etc/lrms/condor.conf\n',
    require => File["/etc/lrms/scheduler.conf"],
    notify  => Class[Bdii::Service],
  }
}
