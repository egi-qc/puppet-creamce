class creamce::gip::provider::glite_info_provider_service_rtepublisher_wrapper inherits creamce::params {

  package { "glite-info-provider-service":
    ensure => present,
  }
  
  file { "$gippath/provider/glite-info-provider-service-rtepublisher-wrapper":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0755,
    content => template("creamce/gip/glite-info-provider-service-rtepublisher-wrapper.erb"),
    require => Package['glite-info-provider-service'],
  }
  
  file{ "/etc/glite/info/service/glite-info-glue2-rtepublisher.conf":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0644,
    content => template("creamce/glite-info-glue2-rtepublisher.conf.erb"),
  }
 
}
