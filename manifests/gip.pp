class creamce::gip inherits creamce::params {

  require creamce::yumrepos
  require creamce::poolaccount

  $queue_vo_map = build_queue_vo_map($grid_queues, $voenv)
  
  $cluster_list = get_clusters_list($subclusters, $glue_2_1)

  package { [
              "bdii",
              "glite-info-provider-service",
              "glite-ce-cream-utils",
              "dynsched-generic",
              "glue-schema"
            ]:
    ensure   => present,
  }
  
  # ##################################################################################################
  # BDII setup
  # ##################################################################################################

  file {"/etc/bdii/bdii.conf":
    content => template('creamce/bdiiconf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    require => Package["bdii"],
    notify  => Service["bdii"],
  }

  file { "/etc/bdii/gip":
    ensure => "directory",
    owner  => "root",
    group  => "root",
    mode   => 0755,
    require => Package["bdii"],
    notify  => Service["bdii"],
  }

  file { "/var/lib/bdii/db":
    ensure => "directory",
    owner  => "ldap",
    group  => "ldap",
    mode   => 0755,
    require => Package["bdii"],
    notify  => Service["bdii"],
  }

  file {"/etc/sysconfig/bdii":
    content => template('creamce/bdiisysconf.erb'),
    owner => 'root',
    group => 'root',
    mode => 0644,
    require => Package["bdii"],
    notify  => Service["bdii"],
  }

  file_line{ 'slapd_threads':
    path => "${slapdconf}",
    match => "^\s*threads",
    line => "threads          ${slapdthreads}",
    require => Package["bdii"],
    notify  => Service["bdii"],
  }

  file_line{ 'slapd_loglevel':
    path => "${slapdconf}",
    match => "^\s*loglevel",
    line  => "loglevel       ${slapdloglevel}",
    require => Package["bdii"],
    notify  => Service["bdii"],
  }


  # ##################################################################################################
  # Experimental features and misc.
  # ##################################################################################################

  if $glue_2_1 {
    file { "/etc/ldap/schema/GLUE2.1-draft.schema":
      ensure  => file,
      owner  => "root",
      group  => "root",
      mode   => 0744,
      content => template("creamce/GLUE2.1-draft.schema.erb"),
      require => Package["glue-schema"],
    }

    exec { "replace_glue_schema_top":
      command => "/usr/bin/sed -i 's/GLUE20.schema/GLUE2.1-draft.schema/g' /etc/bdii/bdii-top-slapd.conf",
      require => File["/etc/ldap/schema/GLUE2.1-draft.schema"],
      notify  => Service["bdii"],
    }

    exec { "replace_glue_schema_resource":
      command => "/usr/bin/sed -i 's/GLUE20.schema/GLUE2.1-draft.schema/g' /etc/bdii/bdii-slapd.conf",
      require => File["/etc/ldap/schema/GLUE2.1-draft.schema"],
      notify  => Service["bdii"],
    }
  }
  
  file { "/var/tmp/puppet-creamce":
    ensure => directory,
    owner  => "root",
    group  => "root",
    mode   => 0644,
  }
  
  file { "/var/tmp/puppet-creamce/replace_infos.sh":
    ensure  => file,
    owner  => "root",
    group  => "root",
    mode   => 0744,
    content => template("creamce/replace_infos.sh.erb"),
    require => File["/var/tmp/puppet-creamce"],
  }

  # ##################################################################################################
  # vo tag dir setup
  # ##################################################################################################

  file { "${gridft_pub_dir}":
    ensure => directory,
    owner  => "root",
    group  => "root",
    mode   => 0755,
  }
  
  $cluster_paths = prefix(keys($subclusters), "${gridft_pub_dir}/")
  file { $cluster_paths:
    ensure => directory,
    owner  => "root",
    group  => "root",
    mode   => 0755,
  }
  
  define tagspace ($pub_dir, $sub_cluster, $a_owner, $a_group, $req_list) {
  
    file { "${pub_dir}/${sub_cluster}/${title}":
      ensure  => directory,
      owner   => "${a_owner}",
      group   => "${a_group}",
      mode    => 0755,
      require => $req_list,
    }

    file { "${pub_dir}/${sub_cluster}/${title}/${title}.list":
      ensure  => file,
      owner   => "${a_owner}",
      group   => "${a_group}",
      mode    => 0644,
      require => File["${pub_dir}/${sub_cluster}/${title}"],
    }

  }
  
  $tagdir_defs = build_tagdir_definitions($voenv, $subclusters, $gridft_pub_dir, 
                                          $username_offset, File[$cluster_paths])
  create_resources(tagspace, $tagdir_defs)


  # ##################################################################################################
  # common plugin 
  # ##################################################################################################

  file {"/etc/glite-ce-glue2/glite-ce-glue2.conf":
    ensure  => file,
    owner   => "root",
    group   => "root",
    mode    => 0755,
    content => template("creamce/gip/glite-ce-glue2.conf.erb"),
    require => Package["glite-ce-cream-utils"],
    notify  => Exec["replace_ce_glue2_facts"],
  }

  exec { "replace_ce_glue2_facts":
    command => "/var/tmp/puppet-creamce/replace_infos.sh /etc/glite-ce-glue2/glite-ce-glue2.conf",
  }
  
  file { "$gippath/plugin/glite-info-cream-glue2":
    ensure  => file,
    owner   => "${info_user}",
    group   => "${info_group}",
    mode    => 0755,
    content => template("creamce/gip/glite-info-cream-glue2.erb"),
    require => File["/etc/glite-ce-glue2/glite-ce-glue2.conf"],
    notify  => Service["bdii"],
  }

  # ##################################################################################################
  # common provider
  # ##################################################################################################

  file{ "/etc/glite/info/service/glite-info-service-cream.conf":
    ensure  => file,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    content => template("creamce/glite-info-service-cream.conf.erb"),
    require => Package["glite-info-provider-service"],
  }
  
  file { "$gippath/provider/glite-info-provider-service-cream-wrapper":
    ensure  => file,
    owner   => "${info_user}",
    group   => "${info_group}",
    mode    => 0755,
    content => template("creamce/gip/glite-info-provider-service-cream-wrapper.erb"),
    require => File["/etc/glite/info/service/glite-info-service-cream.conf"],
    notify  => Service["bdii"],
  }
  
  # ##################################################################################################
  # common ldif
  # ##################################################################################################

  file {"$gippath/ldif/static-file-CE.ldif":
    ensure  => file,
    owner   => "${info_user}",
    group   => "${info_group}",
    mode    => 0644,
    content => template("creamce/gip/static-file-CE.ldif.erb"),
    require => Package["bdii"],
    notify  => Exec["replace_static_CE_facts"],
  }
  
  exec { "replace_static_CE_facts":
    command => "/var/tmp/puppet-creamce/replace_infos.sh $gippath/ldif/static-file-CE.ldif",
    notify  => Service["bdii"],
  }
  
  file { "$gippath/ldif/ComputingEndpoint.ldif":
    ensure  => file,
    mode    => 0644,
    owner   => "${info_user}",
    group   => "${info_group}",
    content => template("creamce/gip/computingendpoint.ldif.erb"),
    require => Package["bdii"],
    notify  => Exec["replace_endpoint_facts"],
  }
  
  exec { "replace_endpoint_facts":
    command => "/var/tmp/puppet-creamce/replace_infos.sh $gippath/ldif/ComputingEndpoint.ldif",
    notify  => Service["bdii"],
  }
  
  file { "$gippath/ldif/ComputingService.ldif":
    ensure  => file,
    mode    => 0644,
    owner   => "${info_user}",
    group   => "${info_group}",
    content => template("creamce/gip/computing_service.ldif.erb"),
    require => Package["bdii"],
    notify  => Service["bdii"],
  }

  file {'/var/tmp/info-dynamic-scheduler-generic':
    ensure  => directory,
    owner   => "${info_user}",
    group   => "${info_group}",
    mode    => 0755,
    require => Package["bdii", "dynsched-generic"],
  }
  
  if $clustermode {
  
    # ################################################################################################
    # ldif files
    # ################################################################################################
    exec {'ComputingShare.ldif.dummy':
      command => "/bin/touch  $gippath/ldif/ComputingShare.ldif",
      require => Package["bdii"],
      notify  => Service["bdii"],
    }  

    exec {'ComputingManager.ldif.dummy':
      command => "/bin/touch  $gippath/ldif/ComputingManager.ldif",
      require => Package["bdii"],
      notify  => Service["bdii"],
    }
    
  } else {
    
    # ################################################################################################
    # plugin
    # ################################################################################################

    file {"$gippath/plugin/glite-info-dynamic-software-wrapper":
      ensure  => file,
      owner   => "${info_user}",
      group   => "${info_group}",
      mode    => 0755,
      content => template("creamce/gip/glite-info-dynamic-software-wrapper.erb"),
      require => [ Package["glite-ce-cream-utils"], File["$gippath/ldif/static-file-Cluster.ldif"] ],
      notify  => Service["bdii"],
    }
  
    # ################################################################################################
    # providers
    # ################################################################################################

    file {"$gippath/provider/glite-info-glue2-applicationenvironment-wrapper":
      ensure  => file,
      owner   => "${info_user}",
      group   => "${info_group}",
      mode    => 0755,
      content => template("creamce/gip/glite-info-glue2-applicationenvironment-wrapper.erb"),
      require => [ Package["glite-ce-cream-utils"], File["$gippath/ldif/static-file-Cluster.ldif", "/etc/glite-ce-glue2/glite-ce-glue2.conf"] ],
      notify  => Service["bdii"],
    }
   
    file{ "/etc/glite/info/service/glite-info-glue2-rtepublisher.conf":
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => 0644,
      content => template("creamce/glite-info-glue2-rtepublisher.conf.erb"),
      require => Package["glite-info-provider-service"],
    }

    file{ "/etc/glite/info/service/glite-info-service-rtepublisher.conf":
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => 0644,
      content => template("creamce/glite-info-service-rtepublisher.conf.erb"),
      require => Package["glite-info-provider-service"],
    }

    file { "$gippath/provider/glite-info-provider-service-rtepublisher-wrapper":
      ensure  => file,
      owner   => "${info_user}",
      group   => "${info_group}",
      mode    => 0755,
      content => template("creamce/gip/glite-info-provider-service-rtepublisher-wrapper.erb"),
      require => File["/etc/glite/info/service/glite-info-glue2-rtepublisher.conf", "/etc/glite/info/service/glite-info-service-rtepublisher.conf"],
      notify  => Service["bdii"],
    }

    # ################################################################################################
    # ldif files
    # ################################################################################################
    file { "$gippath/ldif/ComputingManager.ldif":
      ensure  => file,
      mode    => 0644,
      owner   => "${info_user}",
      group   => "${info_group}",
      content => template("creamce/gip/computing_manager.ldif.erb"),
      require => Package["bdii"],
      notify  => Service["bdii"],
    }

    file { "$gippath/ldif/ComputingShare.ldif":
      ensure  => file,
      mode    => 0644,
      owner   => "${info_user}",
      group   => "${info_group}",
      content => template("creamce/gip/computing_share.ldif.erb"),
      require => Package["bdii"],
      notify  => Service["bdii"],
    }

    file { "$gippath/ldif/ExecutionEnvironment.ldif":
      ensure  => file,
      mode    => 0644,
      owner   => "${info_user}",
      group   => "${info_group}",
      content => template("creamce/gip/executionenvironment.ldif.erb"),
      require => Package["bdii"],
      notify  => Service["bdii"],
    }

    file { "$gippath/ldif/Benchmark.ldif":
      ensure  => file,
      mode    => 0644,
      owner   => "${info_user}",
      group   => "${info_group}",
      content => template("creamce/gip/benchmark.ldif.erb"),
      require => Package["bdii"],
      notify  => Service["bdii"],
    }

    file { "$gippath/ldif/ToStorageService.ldif":
      ensure  => file,
      mode    => 0644,
      owner   => "${info_user}",
      group   => "${info_group}",
      content => template("creamce/gip/tostorageservice.ldif.erb"),
      require => Package["bdii"],
      notify  => Service["bdii"],
    }

    file {"$gippath/ldif/static-file-CESEBind.ldif":
      ensure  => file,
      owner   => "${info_user}",
      group   => "${info_group}",
      mode    => 0644,
      content => template("creamce/gip/static-file-CESEBind.ldif.erb"),
      require => Package["bdii"],
      notify  => Service["bdii"],
    }

    file {"$gippath/ldif/static-file-Cluster.ldif":
      ensure  => file,
      owner   => "${info_user}",
      group   => "${info_group}",
      mode    => 0644,
      content => template("creamce/gip/static-file-Cluster.ldif.erb"),
      require => Package["bdii"],
      notify  => Service["bdii"],
    }  
    
  }
  
  service { "bdii":
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

}
