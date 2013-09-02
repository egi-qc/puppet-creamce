class creamce::gip::ldif::computingshare inherits creamce::params {
  exec {'ComputingShare.ldif':
    command => "/usr/libexec/glite-ce-glue2-share-static /etc/glite-ce-glue2/glite-ce-glue2.conf > $gippath/ldif/ComputingShare.ldif"
  }
  file { "$gippath/ldif/ComputingShare.ldif":
    mode => 0644,
    owner => "ldap",
    group => "ldap",
    require => Exec['ComputingShare.ldif']
  }
}
