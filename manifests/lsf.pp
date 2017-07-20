class creamce::lsf inherits creamce::params {

  include creamce::blah
  include creamce::gip
  
  $vo_group_table = build_vo_group_table($voenv)
  
  # ##################################################################################################
  # BLAHP setup (LSF)
  # ##################################################################################################

  file{ "${blah_config_file}":
    ensure   => present,
    owner    => "root",
    group    => "root",
    mode     => '0644',
    content  => template("creamce/blah.config.lsf.erb"),
  }

  # ##################################################################################################
  # LSF infoproviders
  # ##################################################################################################

  package { "info-dynamic-scheduler-lsf":
    ensure  => present,
    require => Package["dynsched-generic"],
  }

  package { "info-dynamic-scheduler-lsf-btools":
    ensure  => present,
    require => Package["info-dynamic-scheduler-lsf"],
  }

  file{ "/etc/lrms/lsf.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => '0644',
    content => template("creamce/lsf.conf.erb"),
    notify  => Service["bdii"],
  }

  file { "$gippath/plugin/glite-info-dynamic-ce":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => '0755',
    content => template("creamce/gip/glite-info-dynamic-ce-lsf.erb"),
    require => Package["info-dynamic-scheduler-lsf"],
    notify  => Service["bdii"],
  }
  
  file { "/etc/lrms/scheduler.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => '0755',
    content => template("creamce/gip/scheduler.conf.lsf.erb"),
    require => Package["info-dynamic-scheduler-lsf"],   
    notify  => Service["bdii"],
  }
  
  # ##################################################################################################
  # APEL parsers CERN extensions for LSF
  # ##################################################################################################
  if $use_apel and $lsf_config_batchacct {

    $required_pkgs = ["batchacct-common", "batchacct-cecol", "oracle-instantclient-tnsnames.ora"]
    
    package { $required_pkgs:
      ensure => present,
    }
    
    file { "/etc/batchacct/connection":
      ensure  => present,
      owner   => "root",
      group   => "root",
      mode    => '0400',
      content => "${apel_dbname}/${apel_dbpass}@${apel_dbhost}",
      require => Package[$required_pkgs],
      notify  => Service['batchacct-cecold'],
    }
    
    service { "batchacct-cecold":
      ensure => running
    }

  }
      
}
