class creamce::config inherits creamce::params {
  
  case $batch_system {
    lsf: {
      include creamce::lsf
    }
    default: {
      fail "No BATCH system default defined"
    }
  }
  

  file { "${gridmap_dir}":
    ensure => directory,
    owner => "root",
    group => "root",
    mode => 0700,
  }
  
  file { "${cream_db_sandbox_path}":
    ensure => directory,
    owner  => "tomcat",
    group  => "tomcat",
    mode   => 0775,
  }
  
  #
  # TODO create sandbox for supported vo/groups
  #    
  
  file{"/etc/glite/info/service/glite-info-service-cream.conf":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0644,
    content => template("creamce/glite-info-service-cream.conf.erb"),
  }
 
  file{"/etc/sysconfig/edg":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0644,
    content => template("creamce/edg.erb"),
  }
 
  file{"/etc/glite/info/service/glite-info-glue2-rtepublisher.conf":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0644,
    content => template("creamce/glite-info-glue2-rtepublisher.conf.erb"),
  }
 
  file{"/etc/sysconfig/cream":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0400,
    content => template("creamce/cream.erb"),
  }
 
  file {"/etc/glite-ce-cream/cream-config.xml":
    ensure => present,
    content => template("creamce/cream-config.xml.erb"),
    owner => "tomcat",
    group => "tomcat",
    mode => 0640,
  }

  file {"/etc/glite-ce-cream-utils/glite_cream_load_monitor.conf":
    ensure => present,
    content => template("creamce/glite_cream_load_monitor.conf.erb"),
    owner => "tomcat",
    group => "root",
    mode => 0640,
    #fixme: do we need to notify tomcat ?
  }

  #
  # from BLAH
  #
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
  # configure gsi
  # 
  file {"/etc/grid-security/gsi-authz.conf":
    ensure => present,
    content => template("creamce/gsi-authz.erb"),
    owner => "root",
    group=> "root",
    mode => 0644,
  }
  file {"/etc/grid-security/gsi-pep-callout.conf":
    ensure => present,
    content => template("creamce/gsi-pep-callout.conf.erb"),
    owner => "root",
    group=> "root",
    mode => 0644,
  }
  
  #
  # logrotation for BLAH
  #
  file {"/etc/logrotate.d/blahp-logrotate":
    ensure => present,
    content => template("creamce/blahp-logrotate.erb"),
    owner => "root",
    group => "root",
    mode => 0644,
  }
  file {"/etc/logrotate.d/bnotifier-logrotate":
    ensure => present,
    content => template("creamce/bnotifier-logrotate.erb"),
    owner => "root",
    group => "root",
    mode => 0644,
  }
  file {"/etc/logrotate.d/bupdater-logrotate":
    ensure => present,
    content => template("creamce/bupdater-logrotate.erb"),
    owner => "root",
    group => "root",
    mode => 0644,
  }
  file {"/etc/logrotate.d/glexec-logrotate":
    ensure => present,
    content => template("creamce/glexec-logrotate.erb"),
    owner => "root",
    group => "root",
    mode => 0644,
  }
  file {["/opt/edg","/opt/edg/var"]:
    ensure => directory,
    owner => "root",
    group => "root",
    mode => 0755,
  }
}

