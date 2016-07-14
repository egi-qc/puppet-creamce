class creamce::tomcat inherits creamce::params {

  require creamce::yumrepos
  require creamce::certificate

  #
  # tomcat setup is done in a simple way; no need to have a module for now 
  # 
  package { "tomcat-native":
    ensure => absent,
  }
  
  package { "$tomcat":
    ensure  => present,
    require => Package["tomcat-native"],
  }
  
  package { "canl-java-tomcat":
    ensure => present,
    
  }
  
  file { "${tomcat_cert}":
    ensure   => file,
    owner    => "tomcat",
    group    => "root",
    mode     => 0644,
    source   => [$host_certificate],
    require  => Package["$tomcat"],
    notify   => Service[$tomcat]
  }
  
  file { "${tomcat_key}":
    ensure   => file,
    owner    => "tomcat",
    group    => "root",
    mode     => 0400,
    source   => [$host_private_key],
    require  => Package["$tomcat"],
    notify   => Service[$tomcat]
  }

  file {"/etc/${tomcat}/server.xml":
    ensure  => present,
    content => template("creamce/server.xml.erb"),
    owner   => "tomcat",
    group   => "tomcat",
    mode    => 0664,
    notify  => Service["$tomcat"],
    require => Package["${tomcat}", "canl-java-tomcat"],
  }
  
  file {"/etc/${tomcat}/${tomcat}.conf":
    ensure  => present,
    content => template("creamce/tomcat.conf.erb"),
    owner   => "root",
    group   => "root",
    mode    => 0664,
    notify  => Service["$tomcat"],
    require => Package["${tomcat}", "canl-java-tomcat"],
  }

  file {"$tomcat_server_lib/commons-logging.jar":
    ensure => link,
    target => "/usr/share/java/commons-logging.jar",
  }
  
  service { "$tomcat":
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    alias      => "tomcat",
    require    => File["$tomcat_server_lib/commons-logging.jar"]
  }
  
}
