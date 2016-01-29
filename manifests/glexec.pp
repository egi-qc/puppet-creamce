class creamce::glexec inherits creamce::params {

  file { "/usr/sbin/glexec":
    ensure => file,
    owner  => "root",
    group  => "glexec",
    mode   => 6555
  }
  
  file { "/var/log/glexec":
    ensure => directory,
    owner  => "root",
    group  => "root",
    mode   => 0755
  }
  
  file {"/etc/lcmaps/lcmaps-glexec.db":
    ensure => present,
    content => template("creamce/lcmaps-glexec.db.erb"),
    owner => "root",
    group => "root",
    mode => 0640,
  }
  
  file {"/etc/lcas/lcas-glexec.db":
    ensure => present,
    content => template("creamce/lcas-glexec.db.erb"),
    owner => "root",
    group => "root",
    mode => 0644,
  }
  
  file {"/etc/glexec.conf":
    ensure => present,
    content => template("creamce/glexec.conf.erb"),
    owner => "root",
    group => "glexec",
    mode => 0640,
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
