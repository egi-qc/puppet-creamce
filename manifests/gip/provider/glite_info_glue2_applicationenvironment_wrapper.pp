class  creamce::gip::provider::glite_info_glue2_applicationenvironment_wrapper inherits creamce::params {
  file {"$gippath/provider/glite-info-glue2-applicationenvironment-wrapper":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0755,
    content => template("creamce/gip/glite-info-cream-glue2.erb"),
  }
}
