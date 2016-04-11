class creamce::gip::plugin::glite_info_dynamic_software_wrapper inherits creamce::params {

  package { "glite-ce-cream-utils":
    ensure => present
  }

  file {"$gippath/plugin/glite-info-dynamic-software-wrapper":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0755,
    content => template("creamce/gip/glite-info-dynamic-software-wrapper.erb"),
    require => Package['glite-ce-cream-utils'],
  }
  
  file {"$gippath/provider/glite-info-glue2-applicationenvironment-wrapper":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0755,
    content => template("creamce/gip/glite-info-glue2-applicationenvironment-wrapper.erb"),
    require => Package['glite-ce-cream-utils'],
  }
  
}
