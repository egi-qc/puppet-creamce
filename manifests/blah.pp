class creamce::blah inherits creamce::params {

  require creamce::install
  
  # ##################################################################################################
  # BLAHP setup (common actions)
  # ##################################################################################################

  file {"/var/log/cream/accounting":
    ensure => directory,
    owner  => "root",
    group  => "tomcat",
    mode   => '0730',
  }

  file {"/var/blah":
    ensure => directory,
    owner  => "tomcat",
    group  => "tomcat",
    mode   => '0771',
  }

  $file_to_rotate = "/var/log/cream/accounting/blahp.log"
  
  file { "/etc/logrotate.d/blahp-logrotate":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => '0644',
    content => template("creamce/blahp-logrotate.erb"),
  }
  
  unless $use_blparser {
  
    file {"/etc/logrotate.d/bnotifier-logrotate":
      ensure  => present,
      content => template("creamce/bnotifier-logrotate.erb"),
      owner   => "root",
      group   => "root",
      mode    => '0644',
    }

    file {"/etc/logrotate.d/bupdater-logrotate":
      ensure  => present,
      content => template("creamce/bupdater-logrotate.erb"),
      owner   => "root",
      group   => "root",
      mode    => '0644',
    }
  
  }

}
