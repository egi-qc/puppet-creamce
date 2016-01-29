class creamce::certificate inherits creamce::params {
  #
  # Simple set of checks on certificate and key
  #
  
  file { "${host_certificate}":
    ensure => file,
    owner => "root",
    group => "root",
    mode => 0644,
  }

  file { "${host_private_key}":
    ensure => file,
    owner => "root",
    group => "root",
    mode => 0400,
  }
  
  #
  # TODO check certificate expiration 
  #

}
