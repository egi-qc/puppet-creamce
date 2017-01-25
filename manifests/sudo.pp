class creamce::sudo inherits creamce::params {

  require creamce::poolaccount
  
  $sudo_table = build_sudo_table($voenv, $default_pool_size, $username_offset)
  
  package { "sudo":
    ensure => present
  }
  
  file { "/etc/sudoers.d/50_cream_users":
    ensure  => file,
    owner   => "root",
    group   => "root",
    mode    => 0440,
    content => template("creamce/sudoers_forcream.erb"),
    require => Package["sudo"],
  }
  
  unless $sudo_logfile == "" {
  
    file { "${sudo_logfile}":
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => 0640,      
    }
  
  }
  
}
