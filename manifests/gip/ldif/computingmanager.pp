class creamce::gip::ldif::computingmanager inherits creamce::params {
#  exec {'ComputingManager.ldif':
#    command => "/usr/libexec/glite-ce-glue2-manager-static /etc/glite-ce-glue2/glite-ce-glue2.conf > $gippath/ldif/ComputingManager.ldif"
#  }

  file { "$gippath/ldif/ComputingManager.ldif":
    mode => 0644,
    owner => "ldap",
    group => "ldap",
    #require => Exec['ComputingManager.ldif']
    content => template("creamce/gip/computing_manager.ldif.erb"),
  }
  
}
