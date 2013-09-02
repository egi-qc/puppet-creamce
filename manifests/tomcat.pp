class creamce::tomcat inherits params {
  #
  # tomcat setup is done in a simple way; no need to have a module for now 
  # 
  package {$tomcat:
    ensure => present,
  }
  package {"tomcat-native":
    ensure => absent,
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

  file {"$tomcat_server_lib/bcprov.jar":
    ensure => link,
    target => "/usr/share/java/bcprov.jar",
  }
  file {"$tomcat_server_lib/canl.jar":
    ensure => link,
    target => "/usr/share/java/canl.jar",
  }
  file {"$tomcat_server_lib/canl-java-tomcat.jar":
    ensure => link,
    target => "/usr/share/java/canl-java-tomcat.jar",
  }
  file {"$tomcat_server_lib/commons-io.jar":
    ensure => link,
    target => "/usr/share/java/commons-io.jar",
  }
  file {"$tomcat_server_lib/commons-logging.jar":
    ensure => link,
    target => "/usr/share/java/commons-logging.jar",
  }
  
  file {["$tomcat_server_lib/log4j.jar","$tomcat_server_lib/trustmanager.jar","$tomcat_server_lib/trustmanager-tomcat.jar","$tomcat_server_lib/[bcprov].jar","$tomcat_server_lib/[commons-logging].jar","$tomcat_server_lib/[log4j].jar","$tomcat_server_lib/[trustmanager].jar","$tomcat_server_lib/[trustmanager-tomcat].jar"] :
    ensure => absent,
  }
  
  service { $tomcat:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    alias => "tomcat",
  }
  Package[$tomcat] -> File["$tomcat_server_lib/commons-logging.jar","$tomcat_server_lib/bcprov.jar","$tomcat_server_lib/canl.jar","$tomcat_server_lib/canl-java-tomcat.jar","$tomcat_server_lib/canl-java-tomcat.jar","$tomcat_server_lib/commons-io.jar","$tomcat_server_lib/[bcprov].jar","$tomcat_server_lib/[log4j].jar","$tomcat_server_lib/[trustmanager].jar","$tomcat_server_lib/[trustmanager-tomcat].jar"] -> File["/etc/${tomcat}/server.xml"] -> Service[$tomcat]
}
