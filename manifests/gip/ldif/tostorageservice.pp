class creamce::gip::ldif::tostorageservice inherits creamce::params {
  #exec {'ToStorageService.ldif':
  #  command => "/usr/libexec/glite-ce-glue2-tostorageservice-static /etc/glite-ce-glue2/glite-ce-glue2.conf > $gippath/ldif/ToStorageService.ldif"
  #}
  file { "$gippath/ldif/ToStorageService.ldif":
    mode => 0644,
    owner => "ldap",
    group => "ldap",
    #require => Exec['ToStorageService.ldif']
    content => template("creamce/gip/tostorageservice.ldif.erb"),
  }
  
}
