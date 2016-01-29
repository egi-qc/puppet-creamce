class creamce::locallogger inherits creamce::params {

  require creamce::certificate

  file { ["/var/lib/glite","/var/lib/glite/.certs"]:
    ensure => directory,
    owner  => 'glite',
    group  => 'glite',
    mode  => 0755,
  }
    
  file { "/var/lib/glite/.certs/hostcert.pem":
    ensure  => file,
    owner   => "glite",
    group   => "glite",
    mode    => 0644,
    source  => [${host_certificate}],
    require => File["/var/lib/glite/.certs"],
    #notify => Service['glite-lb-locallogger']
  }
  file { "/var/lib/glite/.certs/hostkey.pem":
    ensure  => file,
    owner   => "glite",
    group   => "glite",
    mode    => 0400,
    source  => [${host_private_key}],
    require => File["/var/lib/glite/.certs"],
    #notify => Service['glite-lb-locallogger']
  }

  service {"glite-lb-logd":
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
  }
  service {"glite-lb-locallogger":
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
  }
  service {"glite-lb-interlogd":
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
  }
  

}
