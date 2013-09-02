class creamce::gip::plugin::glite_info_dynamic_software_wrapper inherits creamce::params {
  file {"$gippath/plugin/glite-info-dynamic-software-wrapper":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0755,
    content => template("creamce/gip/glite-info-cream-glue2.erb"),
  }
}
