class creamce::torque inherits creamce::params {

  require creamce::config
  require creamce::gip
  
  $vo_group_table = build_vo_group_table($voenv)
  
  if $torque_use_maui {
    $required_pkgs = ["torque-client", "maui-client", "lcg-pbs-utils"]
  } else {
    $required_pkgs = ["torque-client", "lcg-pbs-utils"]
  }

  package { $required_pkgs:
    ensure  => present,
  }
  
  #
  # configure blah for TORQUE
  #
  file { "/etc/blah.config":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    content => template("creamce/blah.config.torque.erb"),
  }

  #
  # configure infoprovider for TORQUE
  #
  package { "lcg-info-dynamic-scheduler-pbs":
    ensure  => present,
    require => Package[$required_pkgs],
    notify  => Class[Bdii::Service],
  }
  
  file { "/etc/lrms/scheduler.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    content => template("creamce/gip/torque-provider.conf.erb"),
    require => Package["lcg-info-dynamic-scheduler-pbs"],
  }
  
  if $torque_use_maui {
  
    file { "/var/spool/maui/maui.cfg":
      ensure  => present,
      owner   => "root",
      group   => "root",
      mode    => 0644,
      content => template("creamce/maui.cfg.erb"),
      require => Package["maui-client"],
    }
    
  }

}
