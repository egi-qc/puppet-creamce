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

  # ##################################################################################################
  # Service management
  # ##################################################################################################

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

  if $::operatingsystem == "CentOS" and $::operatingsystemmajrelease in [ "7" ] {

    file { ["/etc/systemd/system/glite-lb-logd.service.d",
            "/etc/systemd/system/glite-lb-interlogd.service.d"]:
      ensure => directory,
      owner  => "root",
      group  => "root",
      mode   => '0644',
    }

    file { "/etc/systemd/system/glite-lb-logd.service.d/10-glite-services.conf":
      ensure  => present,
      owner   => "root",
      group   => "root",
      mode    => '0644',
      content => "[Unit]
PartOf=glite-services.target
",
      require => File["/etc/systemd/system/glite-lb-logd.service.d"],
      tag     => [ "glitesystemdfiles" ],
    }
  
    file { "/etc/systemd/system/glite-lb-interlogd.service.d/10-glite-services.conf":
      ensure  => present,
      owner   => "root",
      group   => "root",
      mode    => '0644',
      content => "[Unit]
PartOf=glite-services.target
",
      require => File["/etc/systemd/system/glite-lb-interlogd.service.d"],
      tag     => [ "glitesystemdfiles" ],
    }

  }

}
