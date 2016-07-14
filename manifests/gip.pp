class creamce::gip inherits creamce::params {

  require creamce::yumrepos
  class { "bdii": }

  package { ["glite-info-provider-service", "glite-ce-cream-utils", "dynsched-generic", "glue-schema"]:
    ensure   => present,
    require  => Class["bdii"],
  }

  #
  # common plugin 
  #

  file { "$gippath/plugin/glite-info-cream-glue2":
    ensure  => file,
    owner   => "${info_user}",
    group   => "${info_group}",
    mode    => 0755,
    content => template("creamce/gip/glite-info-cream-glue2.erb"),
    require => Package['glite-info-provider-service'],
  }

  file {"/etc/glite-ce-glue2/glite-ce-glue2.conf":
    ensure  => file,
    owner   => "root",
    group   => "root",
    mode    => 0755,
    content => template("creamce/gip/glite-ce-glue2.conf.erb"),
    require => File["$gippath/plugin/glite-info-cream-glue2"],
  }

  #
  # common ldif
  #
  # ldif files
  file {"$gippath/ldif/static-file-CE.ldif":
    ensure  => file,
    owner   => "${info_user}",
    group   => "${info_group}",
    mode    => 0644,
    content => template("creamce/gip/static-file-CE.ldif.erb"),
    require => Class["bdii"],
  }  
  file { "$gippath/ldif/ComputingEndpoint.ldif":
    ensure  => file,
    mode    => 0644,
    owner   => "${info_user}",
    group   => "${info_group}",
    content => template("creamce/gip/computingendpoint.ldif.erb"),
    require => Class["bdii"],
  }
  file { "$gippath/ldif/ComputingService.ldif":
    ensure  => file,
    mode    => 0644,
    owner   => "${info_user}",
    group   => "${info_group}",
    content => template("creamce/gip/computing_service.ldif.erb"),
    require => Class["bdii"],
  }

  file {'/var/tmp/info-dynamic-scheduler-generic':
    ensure  => directory,
    owner   => "${info_user}",
    group   => "${info_group}",
    mode    => 0755,
    require => Class["bdii"],
  }
  
  if ($clustermode == "true") {
  
    #
    # plugin
    #

    file {"$gippath/plugin/glite-info-provider-service-cream-wrapper":
      ensure  => file,
      owner   => "${info_user}",
      group   => "${info_group}",
      mode    => 0755,
      content => template("creamce/gip/glite-info-provider-service-cream-wrapper.erb"),
      require => Class["bdii"],
    }
    
    #
    # provider
    #
    file { "$gippath/provider/glite-info-provider-service-cream-wrapper":
      ensure  => file,
      owner   => "${info_user}",
      group   => "${info_group}",
      mode    => 0755,
      content => template("creamce/gip/glite-info-provider-service-cream-wrapper.erb"),
      require => Package['glite-info-provider-service'],
    }
  
    file{ "/etc/glite/info/service/glite-info-service-cream.conf":
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => 0644,
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
      ensure  => file,
      owner   => "${info_user}",
      group   => "${info_group}",
      mode    => 0755,
      content => template("creamce/gip/glite-info-dynamic-software-wrapper.erb"),
      require => Package['glite-ce-cream-utils'],
    }
  
    #
    # providers
    #

    file {"$gippath/provider/glite-info-glue2-applicationenvironment-wrapper":
      ensure  => file,
      owner   => "${info_user}",
      group   => "${info_group}",
      mode    => 0755,
      content => template("creamce/gip/glite-info-glue2-applicationenvironment-wrapper.erb"),
      require => Package['glite-ce-cream-utils'],
    }
   
    file { "$gippath/provider/glite-info-provider-service-cream-wrapper":
      ensure  => file,
      owner   => "${info_user}",
      group   => "${info_group}",
      mode    => 0755,
      content => template("creamce/gip/glite-info-provider-service-cream-wrapper.erb"),
      require => Package['glite-info-provider-service'],
    }
  
    file{ "/etc/glite/info/service/glite-info-service-cream.conf":
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => 0644,
      content => template("creamce/glite-info-service-cream.conf.erb"),
    }
  
    file { "$gippath/provider/glite-info-provider-service-rtepublisher-wrapper":
      ensure  => file,
      owner   => "${info_user}",
      group   => "${info_group}",
      mode    => 0755,
      content => template("creamce/gip/glite-info-provider-service-rtepublisher-wrapper.erb"),
      require => Package['glite-info-provider-service'],
    }
  
    file{ "/etc/glite/info/service/glite-info-glue2-rtepublisher.conf":
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => 0644,
      content => template("creamce/glite-info-glue2-rtepublisher.conf.erb"),
      require => Class["bdii"],
    }

    #
    # ldif files
    #
    file { "$gippath/ldif/ComputingManager.ldif":
      ensure  => file,
      mode    => 0644,
      owner   => "${info_user}",
      group   => "${info_group}",
      content => template("creamce/gip/computing_manager.ldif.erb"),
      require => Class["bdii"],
    }
    file { "$gippath/ldif/ComputingShare.ldif":
      ensure  => file,
      mode    => 0644,
      owner   => "${info_user}",
      group   => "${info_group}",
      content => template("creamce/gip/computing_share.ldif.erb"),
      require => Class["bdii"],
    }
    file { "$gippath/ldif/ExecutionEnvironment.ldif":
      ensure  => file,
      mode    => 0644,
      owner   => "${info_user}",
      group   => "${info_group}",
      content => template("creamce/gip/executionenvironment.ldif.erb"),
      require => Class["bdii"],
    }
    file { "$gippath/ldif/Benchmark.ldif":
      ensure  => file,
      mode    => 0644,
      owner   => "${info_user}",
      group   => "${info_group}",
      content => template("creamce/gip/benchmark.ldif.erb"),
      require => Class["bdii"],
    }
    file { "$gippath/ldif/ToStorageService.ldif":
      ensure  => file,
      mode    => 0644,
      owner   => "${info_user}",
      group   => "${info_group}",
      content => template("creamce/gip/tostorageservice.ldif.erb"),
      require => Class["bdii"],
    }
    file {"$gippath/ldif/static-file-CESEBind.ldif":
      ensure  => file,
      owner   => "${info_user}",
      group   => "${info_group}",
      mode    => 0644,
      content => template("creamce/gip/static-file-CESEBind.ldif.erb"),
      require => Class["bdii"],
    }
    file {"$gippath/ldif/static-file-Cluster.ldif":
      ensure  => file,
      owner   => "${info_user}",
      group   => "${info_group}",
      mode    => 0644,
      content => template("creamce/gip/static-file-Cluster.ldif.erb"),
      require => Class["bdii"],
    }  
    
  }
}
