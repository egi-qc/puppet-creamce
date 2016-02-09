class creamce::gip::ldif::staticfilece inherits creamce::params {
  file {"$gippath/ldif/static-file-CE.ldif":
    ensure => present,
    owner => "ldap",
    group => "ldap",
    mode => 0644,
    content => template("creamce/gip/static-file-CE.ldif.erb"),
  }  
}
