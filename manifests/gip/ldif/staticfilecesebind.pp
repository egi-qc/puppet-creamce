class creamce::gip::ldif::staticfilecesebind inherits creamce::params {
  file {"$gippath/ldif/static-file-CESEBind.ldif":
    ensure => present,
    owner => "ldap",
    group => "ldap",
    mode => 0644,
    content => template("creamce/gip/static-file-CESEBind.ldif.erb"),
  }
}
