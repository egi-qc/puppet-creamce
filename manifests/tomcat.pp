class creamce::tomcat inherits creamce::params {

  require creamce::certificate

  #
  # tomcat setup is done in a simple way; no need to have a module for now 
  # 
  package {$tomcat:
    ensure => present,
  }
  package {"tomcat-native":
    ensure => absent,
  }
  
  #
  # derive tomcat certs
  #
  file { "${tomcat_cert}":
    ensure => file,
    owner => "tomcat",
    group => "root",
    mode => 0644,
    source => [$host_certificate],
    notify => Service[$tomcat]
  }
  file { "${tomcat_key}":
    ensure => file,
    owner => "tomcat",
    group => "root",
    mode => 0400,
    source => [$host_private_key],
    notify => Service[$tomcat]
  }

  file {"/etc/${tomcat}/server.xml":
    ensure => present,
    content => template("creamce/server.xml.erb"),
    owner => "tomcat",
    group => "tomcat",
    mode => 0664,
    notify => Service["$tomcat"]

  }
  
  file {"/etc/${tomcat}/${tomcat}.conf":
    ensure => present,
    content => template("creamce/tomcat.conf.erb"),
    owner => "root",
    group => "root",
    mode => 0664,
  }

  file {"$tomcat_server_lib/commons-logging.jar":
    ensure => link,
    target => "/usr/share/java/commons-logging.jar",
  }
  
  service { $tomcat:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    alias => "tomcat",
  }
  
  Package[$tomcat] -> File["$tomcat_server_lib/commons-logging.jar"] -> File["/etc/${tomcat}/server.xml"] -> Service[$tomcat]
  
}
