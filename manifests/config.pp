class creamce::config inherits creamce::params {
  
  require creamce::certificate
  
  require creamce::install
  
  require creamce::env
  
  require creamce::sudo
  
  require creamce::voms
  
  require creamce::creamdb
  
  # ##################################################################################################
  # Tomcat setup
  # ##################################################################################################

  file { "${tomcat_cert}":
    ensure   => file,
    owner    => "tomcat",
    group    => "root",
    mode     => 0644,
    source   => [$host_certificate],
    notify   => Service[$tomcat]
  }
  
  file { "${tomcat_key}":
    ensure   => file,
    owner    => "tomcat",
    group    => "root",
    mode     => 0400,
    source   => [$host_private_key],
    notify   => Service[$tomcat]
  }

  file {"/etc/${tomcat}/server.xml":
    ensure  => present,
    content => template("creamce/server.xml.erb"),
    owner   => "tomcat",
    group   => "tomcat",
    mode    => 0664,
    notify  => Service["$tomcat"],
  }
  
  file {"/etc/${tomcat}/${tomcat}.conf":
    ensure  => present,
    content => template("creamce/tomcat.conf.erb"),
    owner   => "root",
    group   => "root",
    mode    => 0664,
    notify  => Service["$tomcat"],
  }

  service { "$tomcat":
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    alias      => "tomcat",
  }

  # ##################################################################################################
  # CREAM setup
  # ##################################################################################################

  file { "${cream_db_sandbox_path}":
    ensure => directory,
    owner  => "tomcat",
    group  => "tomcat",
    mode   => 0775,
  }
  
  $sb_definitions = build_sb_definitions($voenv, $cream_db_sandbox_path, File["$cream_db_sandbox_path"])
  create_resources(file, $sb_definitions)
  
  file{"/etc/sysconfig/edg":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    content => template("creamce/edg.erb"),
  }
 
  file{"/etc/sysconfig/cream":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0400,
    content => template("creamce/cream.erb"),
    notify  => Service["$tomcat"],
  }
 
  file {"/etc/glite-ce-cream/cream-config.xml":
    ensure  => present,
    content => template("creamce/cream-config.xml.erb"),
    owner   => "tomcat",
    group   => "tomcat",
    mode    => 0640,
    notify  => Service["$tomcat"],
  }

  file {"/etc/glite-ce-cream-utils/glite_cream_load_monitor.conf":
    ensure => present,
    content => template("creamce/glite_cream_load_monitor.conf.erb"),
    owner => "tomcat",
    group => "root",
    mode => 0640,
    notify  => Service["$tomcat"],
  }

  file { "${cream_admin_list_file}":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    content => template("creamce/adminlist.erb"),
    notify  => Service["$tomcat"],
  }  

  # ##################################################################################################
  # BLAHP setup (common actions)
  # ##################################################################################################

  file {"/var/log/cream/accounting":
    ensure => directory,
    owner => "root",
    group => "tomcat",
    mode => 0730,
  }

  file {"/var/blah":
    ensure => directory,
    owner => "tomcat",
    group => "tomcat",
    mode => 0771,
  }

  #
  # logrotation for BLAH
  #
  file {"/etc/logrotate.d/blahp-logrotate":
    ensure  => present,
    content => template("creamce/blahp-logrotate.erb"),
    owner   => "root",
    group   => "root",
    mode    => 0644,
  }

  if $blparser_with_updater {
  
    file {"/etc/logrotate.d/bnotifier-logrotate":
      ensure  => present,
      content => template("creamce/bnotifier-logrotate.erb"),
      owner   => "root",
      group   => "root",
      mode    => 0644,
    }

    file {"/etc/logrotate.d/bupdater-logrotate":
      ensure  => present,
      content => template("creamce/bupdater-logrotate.erb"),
      owner   => "root",
      group   => "root",
      mode    => 0644,
    }
  
  }

}

