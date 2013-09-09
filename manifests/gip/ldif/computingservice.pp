class creamce::gip::ldif::computingservice inherits creamce::params {
#  exec {'ComputingService.ldif':
#    command => "/usr/libexec/glite-ce-glue2-computingservice-static /etc/glite-ce-glue2/glite-ce-glue2.conf > $gippath/ldif/ComputingService.ldif"
#  }
  
  file { "$gippath/ldif/ComputingService.ldif":
    mode => 0644,
    owner => "ldap",
    group => "ldap",
    #require => Exec['ComputingService.ldif']
    content => template("creamce/gip/computing_service.ldif.erb"),
  }
  
}
