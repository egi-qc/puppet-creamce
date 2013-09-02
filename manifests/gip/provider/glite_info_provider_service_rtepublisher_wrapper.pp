class creamce::gip::provider::glite_info_provider_service_rtepublisher_wrapper inherits creamce::params {
  file {"$gippath/provider/glite-info-provider-service-rtepublisher-wrapper":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0755,
    content => template("creamce/gip/glite-info-cream-glue2.erb"),
  }
}
