class creamce::gip::plugin::glite_info_cream_glue2 inherits creamce::params {
  file {"$gippath/plugin/glite-info-cream-glue2":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0755,
    content => template("creamce/gip/glite-info-cream-glue2.erb"),
  }
  file {"/etc/glite-ce-glue2/glite-ce-glue2.conf":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0755,
    content => template("creamce/gip/glite-ce-glue2.conf.erb"),
  }
}
