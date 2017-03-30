class creamce::lsf inherits creamce::params {

  include creamce::blah
  require creamce::gip
  
  # ##################################################################################################
  # BLAHP setup (LSF)
  # ##################################################################################################

  file{ "${blah_config_file}":
    ensure   => present,
    owner    => "root",
    group    => "root",
    mode     => 0644,
    content  => template("creamce/blah.config.lsf.erb"),
  }

  file { "/usr/libexec/lsf_local_submit_attributes.sh":
        ensure => present,
        owner => "root",
        group => "root",
        mode => 0755,
        content => template("creamce/lsf_local_submit_attributes.sh.erb"),
  }
  
  # ##################################################################################################
  # LSF infoproviders
  # ##################################################################################################

  package { "info-dynamic-scheduler-lsf":
    ensure  => present,
    require => Package["dynsched-generic"],
    notify  => Class[Bdii::Service],
  }

  file{ "/etc/lrms/lsf.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    content => template("creamce/lsf.conf.erb"),
  }

  file { "$gippath/plugin/glite-info-dynamic-ce":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0755,
    content => template("creamce/gip/glite-info-dynamic-ce-lsf.erb"),
    require => Package["info-dynamic-scheduler-lsf"],
  }
  
  file { "/etc/lrms/scheduler.conf":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0755,
    content => template("creamce/gip/scheduler.conf.lsf.erb"),
    require => Package["info-dynamic-scheduler-lsf"],   
  }
  
  # ##################################################################################################
  # APEL parsers for LSF
  # ##################################################################################################
  if $lsf_config_apel {

    $required_pkgs = ["apel-parsers", "batchacct-common", "batchacct-cecol", "oracle-instantclient-tnsnames.ora"]
    
    package { $required_pkgs:
      ensure => present,
    }
    
    file { "/etc/batchacct/connection":
      ensure  => present,
      owner   => "root",
      group   => "root",
      mode    => 0400,
      content => template("creamce/apelconf.erb"),
      require => Package[$required_pkgs],
      notify  => Service['batchacct-cecold'],
    }
    
    service { "batchacct-cecold":
      ensure => running
    }

  }
      
}
