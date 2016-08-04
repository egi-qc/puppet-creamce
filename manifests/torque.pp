class creamce::torque inherits creamce::params {

  require creamce::config
  require creamce::gip
  
  $vo_group_table = build_vo_group_table($voenv)
  
  if $torque_use_maui {
    $required_pkgs = ["torque-client", "munge", "maui-client", "lcg-pbs-utils"]
  } else {
    $required_pkgs = ["torque-client", "munge", "lcg-pbs-utils"]
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
  
  #
  # configure torque client
  #
  
  # TODO missing workaround for bug 5530

  exec { "cleanup_sshd_config":
    command => "/bin/sed -i -e '/^\s*HostbasedAuthentication/d' -e '/^\s*IgnoreUserKnownHosts/d' -e '/^\s*IgnoreRhosts/d' /etc/ssh/sshd_config",
  }
  
  exec { "fillin_sshd_config":
    command => "/bin/echo \"
HostbasedAuthentication = yes
IgnoreUserKnownHosts yes
IgnoreRhosts yes\" >> /etc/ssh/sshd_config",
    require => Exec["cleanup_sshd_config"],
  }


  $tmp_list = join(keys($se_list), " ")
  
  file { "/etc/edg-pbs-shostsequiv.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    content => "SHOSTSEQUIV = /etc/ssh/shosts.equiv
NODES       =  ${torque_server} ${ce_host} ${tmp_list} 
PBSBIN      = /usr/bin
",
    require => [Package["lcg-pbs-utils"], Exec["fillin_sshd_config"]],
  }
  
  file { "/etc/cron.d/edg-pbs-shostsequiv":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    content => "${torque_ssh_cron_sched} root /usr/sbin/edg-pbs-shostsequiv",
    require => File["/etc/edg-pbs-shostsequiv.conf"],
  }
  
  exec { "/usr/sbin/edg-pbs-shostsequiv":
    require => File["/etc/edg-pbs-shostsequiv.conf"],
  }
  
  file { "/etc/edg-pbs-knownhosts.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    content => "NODES = ${torque_server} ${ce_host} ${tmp_list} 
PBSBIN = /usr/bin
KEYTYPES = rsa1,rsa,dsa
KNOWNHOSTS = /etc/ssh/ssh_known_hosts
",
    require => [Package["lcg-pbs-utils"], Exec["fillin_sshd_config"]],
  }
  
  file { "/etc/cron.d/edg-pbs-knownhosts":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    content => "${torque_ssh_cron_sched} root /usr/sbin/edg-pbs-knownhosts",
    require => File["/etc/edg-pbs-knownhosts.conf"],
  }
  
  exec { "/usr/sbin/edg-pbs-knownhosts":
    require => File["/etc/edg-pbs-knownhosts.conf"],
  }
  
  exec { "register_torque_server":
    command => "/bin/echo ${torque_server} > /etc/torque/server_name",
    require => Package["torque-client"],
  }
  
  service { "munge":
    ensure => running,
  }
  
  if $munge_key_path == "" {

    notify { "missing_munge_key":
      message => "Munge key not installed; it must be installed manually",
    }

  } else {

    file { "/etc/munge/munge.key":
      ensure  => present,
      owner   => "munge",
      group   => "munge",
      mode    => 0400,
      source  => "${munge_key_path}",
      require => Package["munge"],
      notify  => Service["munge"],
    }

  }

}
