class creamce::certificate inherits creamce::params {

  require fetchcrl
  
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
  
}
