class creamce::gip::provider::glite_info_provider_service_cream_wrapper inherits creamce::params {
  file {"$gippath/provider/glite-info-provider-service-cream-wrapper":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0755,
    content => template("creamce/gip/glite-info-cream-glue2.erb"),
  }
}
