class creamce::gip::plugin::glite_info_dynamic_ce inherits creamce::params {

# the wrapper is batch system specific and should be filled there. Here we create
# the required ldif files only
  file {"$gippath/ldif/static-file-CE.ldif":
    ensure => present,
    owner => "ldap",
    group => "ldap",
    mode => 0644,
    content => template("creamce/gip/static-file-CE.ldif.erb"),
  }  
}
