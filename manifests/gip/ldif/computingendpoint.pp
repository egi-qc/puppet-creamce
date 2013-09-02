class creamce::gip::ldif::computingendpoint inherits creamce::params {
  exec {'ComputingEndpoint.ldif':
    command => "/usr/libexec/glite-ce-glue2-endpoint-static /etc/glite-ce-glue2/glite-ce-glue2.conf > $gippath/ldif/ComputingEndpoint.ldif"
  }
  file { "$gippath/ldif/ComputingEndpoint.ldif":
    mode => 0644,
    owner => "ldap",
    group => "ldap",
    require => Exec['ComputingEndpoint.ldif']
  }
  
}
