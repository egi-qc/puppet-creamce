class creamce::gip inherits creamce::params {

  require creamce::yumrepos
  require bdii

  package { "glite-info-provider-service":
    ensure => present
  }

  package { "glite-ce-cream-utils":
    ensure => present
  }

  package { "dynsched-generic":
    ensure => present
  }

  package { "glue-schema":
    ensure => present
  }

  #
  # common plugin 
  #

  file {"$gippath/plugin/glite-info-cream-glue2":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0755,
    content => template("creamce/gip/glite-info-cream-glue2.erb"),
    require => Package['glite-info-provider-service'],
  }

  file {"/etc/glite-ce-glue2/glite-ce-glue2.conf":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0755,
    content => template("creamce/gip/glite-ce-glue2.conf.erb"),
  }

  #
  # common ldif
  #
  # ldif files
  include creamce::gip::ldif::staticfilece
  include creamce::gip::ldif::computingendpoint
  include creamce::gip::ldif::computingservice

  file {'/var/tmp/info-dynamic-scheduler-generic':
    ensure => directory,
    owner  => 'ldap',
    group  => 'ldap',
    mode   => 0755
  }
  
  if ($clustermode == "true") {
  
    #
    # plugin
    #

    file {"$gippath/plugin/glite-info-provider-service-cream-wrapper":
      ensure => present,
      owner => "root",
      group => "root",
      mode => 0755,
      content => template("creamce/gip/glite-info-provider-service-cream-wrapper.erb"),
    }
    
    #
    # provider
    #
    file { "$gippath/provider/glite-info-provider-service-cream-wrapper":
      ensure => present,
      owner => "root",
      group => "root",
      mode => 0755,
      content => template("creamce/gip/glite-info-provider-service-cream-wrapper.erb"),
      require => Package['glite-info-provider-service'],
    }
  
    file{ "/etc/glite/info/service/glite-info-service-cream.conf":
      ensure => present,
      owner => "root",
      group => "root",
      mode => 0644,
      content => template("creamce/glite-info-service-cream.conf.erb"),
    }
    
    #
    # ldif files
    #
    exec {'ComputingShare.ldif.dummy':
      command => "/bin/touch  $gippath/ldif/ComputingShare.ldif"
    }  
    exec {'ComputingManager.ldif.dummy':
      command => "/bin/touch  $gippath/ldif/ComputingManager.ldif"
    }
    
  } else {
    
    #
    # plugin
    #

    file {"$gippath/plugin/glite-info-dynamic-software-wrapper":
      ensure => present,
      owner => "root",
      group => "root",
      mode => 0755,
      content => template("creamce/gip/glite-info-dynamic-software-wrapper.erb"),
      require => Package['glite-ce-cream-utils'],
    }
  
    #
    # providers
    #

    file {"$gippath/provider/glite-info-glue2-applicationenvironment-wrapper":
      ensure => present,
      owner => "root",
      group => "root",
      mode => 0755,
      content => template("creamce/gip/glite-info-glue2-applicationenvironment-wrapper.erb"),
      require => Package['glite-ce-cream-utils'],
    }
   
    file { "$gippath/provider/glite-info-provider-service-cream-wrapper":
      ensure => present,
      owner => "root",
      group => "root",
      mode => 0755,
      content => template("creamce/gip/glite-info-provider-service-cream-wrapper.erb"),
      require => Package['glite-info-provider-service'],
    }
  
    file{ "/etc/glite/info/service/glite-info-service-cream.conf":
      ensure => present,
      owner => "root",
      group => "root",
      mode => 0644,
      content => template("creamce/glite-info-service-cream.conf.erb"),
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

    #
    # ldif files
    #
    include creamce::gip::ldif::computingmanager
    include creamce::gip::ldif::executionenvironment
    include creamce::gip::ldif::tostorageservice
    include creamce::gip::ldif::staticfilecesebind
    include creamce::gip::ldif::computingshare
    include creamce::gip::ldif::staticfilecluster
    include creamce::gip::ldif::benchmark
    
  }
}
