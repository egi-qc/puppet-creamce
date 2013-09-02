class creamce::gip::ldif::executionenvironment inherits creamce::params {
  exec {'ExecutionEnvironment.ldif':
    command => "/usr/libexec/glite-ce-glue2-executionenvironment-static /etc/glite-ce-glue2/glite-ce-glue2.conf > $gippath/ldif/ExecutionEnvironment.ldif"
  }
  file { "$gippath/ldif/ExecutionEnvironment.ldif":
    mode => 0644,
    owner => "ldap",
    group => "ldap",
    require => Exec['ExecutionEnvironment.ldif']
  }

}
