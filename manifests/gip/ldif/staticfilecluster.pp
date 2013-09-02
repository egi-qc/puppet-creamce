class creamce::gip::ldif::staticfilecluster inherits creamce::params {
  file {"$gippath/ldif/static-file-Cluster.ldif":
    ensure => present,
    owner => "ldap",
    group => "ldap",
    mode => 0644,
    content => template("creamce/gip/static-file-Cluster.ldif.erb"),
  }  
}
