class creamce::lsf inherits creamce::params {

  require creamce::config
  require creamce::gip
  
  #
  # add and configure LSF batch system
  # 
  include lsf

  package {["emi-lsf-utils","btools","info-dynamic-scheduler-lsf"]:
    ensure  => present,
    require => Package["dynsched-generic"],
    notify  => Class[Bdii::Service],
  }

  #
  # configure blah for LSF
  #
  file{"/etc/blah.config":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0644,
    content => template("creamce/blah.config.lsf.erb"),
  }

  file{"/etc/profile.lsf":
    ensure => symlink,
    target  => '/usr/etc/profile.lsf',
  }


  # configure LSF information providers for CERN
  file{"/etc/lrms/lsf.conf":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0644,
    content => template("creamce/lsf.conf.erb"),
  }

  file {"$gippath/plugin/glite-info-dynamic-ce":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0755,
    content => template("creamce/gip/glite-info-dynamic-ce-lsf.erb"),
  }
  
  file {"/etc/lrms/scheduler.conf":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0755,
    content => template("creamce/gip/scheduler.conf.lsf.erb"),    
  }
  
  file {"/usr/libexec/lsf_local_submit_attributes.sh":
        ensure => present,
        owner => "root",
        group => "root",
        mode => 0755,
        content => template("creamce/lsf_local_submit_attributes.sh.erb"),
  }
  
  # configure apel parser
  package { ["batchacct-common", "batchacct-cecol", "oracle-instantclient-tnsnames.ora"]:
    ensure => present,
  }
  
  file { "/etc/batchacct/connection":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0400,
    content => template("creamce/apelconf.erb"),
    require => Package["batchacct-common", "batchacct-cecol", "oracle-instantclient-tnsnames.ora"],
    notify  => Service['batchacct-cecold'],
  }
  
  service { "batchacct-cecold":
    ensure => running
  }
      
}
