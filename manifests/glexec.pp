class creamce::glexec inherits creamce::params {

  require creamce::yumrepos
  
  $config_glexec = true

  package { "lcmaps-plugins-basic":
    ensure => present
  }

  package { "lcmaps-plugins-voms":
    ensure => present
  }

  package { "lcmaps-plugins-verify-proxy":
    ensure => present
  }

  package { "lcas-plugins-basic":
    ensure => present
  }

  package { "lcas-plugins-voms":
    ensure => present
  }

  package { "lcas-plugins-check-executable":
    ensure => present
  }

  package { "lcg-expiregridmapdir":
    ensure => present
  }

  package { "glexec":
    ensure  => present,
    require => Package["lcmaps-plugins-basic", "lcmaps-plugins-voms", "lcmaps-plugins-verify-proxy", "lcas-plugins-basic", "lcas-plugins-voms", "lcas-plugins-check-executable", "lcg-expiregridmapdir"]
  }

  file { "/usr/sbin/glexec":
    ensure  => file,
    owner   => "root",
    group   => "glexec",
    mode    => 6555,
    require => Package["glexec"]
  }
  
  file { "/var/log/glexec":
    ensure => directory,
    owner  => "root",
    group  => "root",
    mode   => 0755,
    require => Package["glexec"]
  }
  
  file {"/etc/lcmaps/lcmaps-glexec.db":
    ensure => present,
    content => template("creamce/lcmaps-glexec.db.erb"),
    owner => "root",
    group => "root",
    mode => 0640,
    require => Package["glexec"]
  }
  
  file {"/etc/lcas/lcas-glexec.db":
    ensure => present,
    content => template("creamce/lcas-glexec.db.erb"),
    owner => "root",
    group => "root",
    mode => 0644,
    require => Package["glexec"]
  }
  
  file {"/etc/glexec.conf":
    ensure => present,
    content => template("creamce/glexec.conf.erb"),
    owner => "root",
    group => "glexec",
    mode => 0640,
    require => Package["glexec"]
  }
  
  # TODO logrotate
  #file {"/etc/logrotate.d/glexec":
  #  ensure => present,
  #  content => template("creamce/glexec-logrotate.erb"),
  #  owner => "root",
  #  group => "root",
  #  mode => 0644,
  #}

}
