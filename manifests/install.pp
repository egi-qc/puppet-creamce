class creamce::install inherits creamce::params {

  require creamce::yumrepos

  package { "tomcat-native":
    ensure => absent,
  }
  
  package { "$tomcat":
    ensure  => present,
    require => Package["tomcat-native"],
  }
  
  package { ["glite-ce-cream",
             "BLAH",
             "canl-java-tomcat",
             "mysql-connector-java"]: 
    ensure   => present,
    require  => Package["${tomcat}"],
  }
  
  file { "${tomcat_server_lib}/commons-logging.jar":
    ensure    => link,
    target    => "/usr/share/java/commons-logging.jar",
    subscribe => Package["${tomcat}"],
  }
    
}



