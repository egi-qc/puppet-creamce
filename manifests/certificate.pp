class creamce::certificate inherits creamce::params {
  #
  # setup the host certificate and stuff
  # Note: cannot use the standart procedure because we need to apply some bug fixes and copy the cert around
  #
  
  $hostcert='/etc/grid-security/hostcert.pem' 
  $hostkey='/etc/grid-security/hostkey.pem'
  $owner='root'
  $group='root' 
  $hostcert_mode='0644'
  $hostkey_mode='0400'
  $subject=$::fqdn
  
  file { $hostcert:
    ensure => file,
    owner => "root",
    group => "root",
    mode => 0644,
    source => ["/var/lib/puppet/ssl/certs/${subject}.pem"], 
  }
  exec {'convert_hostkey':
    command => "/usr/bin/openssl rsa -in /var/lib/puppet/ssl/private_keys/${subject}.pem -out $hostkey && /bin/chown root.root $hostkey && /bin/chmod 400 $hostkey "
  }

  #
  # derive tomcat certs
  #
  file { "/etc/grid-security/tomcat-cert.pem":
    ensure => file,
    owner => "tomcat",
    group => "root",
    mode => 0644,
    source => [$hostcert],
    notify => Service[$tomcat]
  }
  file { "/etc/grid-security/tomcat-key.pem":
    ensure => file,
    owner => "tomcat",
    group => "root",
    mode => 0400,
    source => [$hostkey],
    notify => Service[$tomcat]
  }
  #
  # derive glite certs
  #
  file { ["/var/lib/glite","/var/lib/glite/.certs"]:
    ensure => directory,
    owner => 'glite',
    group => 'glite',
    mode => 0755,
  }
    
  file { "/var/lib/glite/.certs/hostcert.pem":
    ensure => file,
    owner => "glite",
    group => "glite",
    mode => 0644,
    source => [$hostcert],
    require => File["/var/lib/glite/.certs"],
    notify => Service['glite-lb-locallogger']
  }
  file { "/var/lib/glite/.certs/hostkey.pem":
    ensure => file,
    owner => "glite",
    group => "glite",
    mode => 0400,
    source => [$hostkey],
    require => File["/var/lib/glite/.certs"],
    notify => Service['glite-lb-locallogger']
  }
  File[$hostcert] -> Exec['convert_hostkey'] -> File["/etc/grid-security/tomcat-cert.pem","/etc/grid-security/tomcat-key.pem","/var/lib/glite/.certs/hostcert.pem","/var/lib/glite/.certs/hostkey.pem"]
}
