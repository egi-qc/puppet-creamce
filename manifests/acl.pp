class creamce::acl inherits params {
  file {"/etc/grid-security/admin-list":
    ensure => present,
    content => template("creamce/adminlist.erb"),
    owner => "root",
    group => "root",
    mode => 0644,
  }  
}
