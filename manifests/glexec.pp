class creamce::glexec inherits creamce::params {

  require creamce::lcmaps
  
  package { "glexec":
    ensure  => present,
  }

  file { "/usr/sbin/glexec":
    ensure  => file,
    owner   => "root",
    group   => "glexec",
    mode    => '6555',
    require => Package["glexec"]
  }
  
  file { "/var/log/glexec":
    ensure  => directory,
    owner   => "root",
    group   => "root",
    mode    => '0755',
    require => Package["glexec"]
  }
  
  file {"/etc/glexec.conf":
    ensure  => present,
    content => template("creamce/glexec.conf.erb"),
    owner   => "root",
    group   => "glexec",
    mode    => '0640',
    require => Package["glexec"]
  }
  
  unless $glexec_log_file == "" {

    file {"/etc/logrotate.d/glexec":
      ensure  => present,
      content => template("creamce/glexec-logrotate.erb"),
      owner   => "root",
      group   => "root",
      mode    => '0644',
      require => Package["glexec"]
    }

  }

}
