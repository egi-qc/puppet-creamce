class creamce::locallogger inherits creamce::params {

  require creamce::certificate
  
  package { "glite-lb-logger":
    ensure => present,
    tag    => [ "loggerpackages", "umdpackages" ],
  }
  
  group { "${loclog_group}":
    ensure   => present,
  }
  
  user { "${loclog_user}":
    ensure   => present,
    gid      => "${loclog_group}",
    require  => Group["${loclog_group}"],
  }

  file { ["${loclog_dir}","${loclog_dir}/.certs"]:
    ensure   => directory,
    owner    => "${loclog_user}",
    group    => "${loclog_group}",
    mode     => '0755',
    require  => User["${loclog_user}"],
  }
    
  file { "${loclog_dir}/.certs/hostcert.pem":
    ensure  => file,
    owner   => "${loclog_user}",
    group   => "${loclog_group}",
    mode    => '0644',
    source  => [ "${host_certificate}" ],
    require => File["${loclog_dir}/.certs", "${host_certificate}"],
    notify  => Service["glite-lb-logd", "glite-lb-interlogd"]
  }
  
  file { "${loclog_dir}/.certs/hostkey.pem":
    ensure  => file,
    owner   => "${loclog_user}",
    group   => "${loclog_group}",
    mode    => '0400',
    source  => [ "${host_private_key}" ],
    require => File["${loclog_dir}/.certs", "${host_private_key}"],
    notify  => Service["glite-lb-logd", "glite-lb-interlogd"]
  }
  
  file {"/etc/cron.d/locallogger.cron":
    ensure    => present,
    content   => template("creamce/locallogger.cron.erb"),
    mode      => '0644',
    require   => [ File["${loclog_dir}/.certs/hostcert.pem"], Package["glite-lb-logger"] ],
  }

  service { "glite-lb-logd":
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    require    => Package["glite-lb-logger"],
  }

  service { "glite-lb-interlogd":
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    require    => Service["glite-lb-logd"],
  }

}
