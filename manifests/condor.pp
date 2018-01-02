class creamce::condor inherits creamce::params {

  include creamce::blah
  include creamce::gip
  
  $vo_group_table = build_vo_group_table($voenv)
  
  # ##################################################################################################
  # configure blah for Condor
  # ##################################################################################################
  
  if $condorversion >= "080601" {
    info "Applying patch for classads"
    
    package { "condor-classads-blah-patch":
      ensure  => present,
      before  => Package["glite-ce-cream"],
    }

  }
  
  file{ "${blah_config_file}":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => '0644',
    content => template("creamce/blah.config.condor.erb"),
  }

  # ##################################################################################################
  # configure infoprovider for Condor
  # ##################################################################################################
  
  package { "lcg-info-dynamic-scheduler-condor":
    ensure  => present,
    require => Package["bdii"],
    tag     => [ "bdiipackages", "umdpackages" ],
  }
  
  file { "${condor_conf_dir}/bdii_setup.config":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => '0644',
    content => "QUEUE_SUPER_USERS = $(QUEUE_SUPER_USERS), ldap\n",
    before  => File["/etc/lrms/scheduler.conf"],
  }
  
  file { "/etc/lrms/scheduler.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => '0644',
    content => template("creamce/gip/condor-provider.conf.erb"),
    require => Package["lcg-info-dynamic-scheduler-condor"],
  }
  
  file { "/etc/lrms/condor.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => '0644',
    content => template("creamce/gip/condor.conf.erb"),
    require => Package["lcg-info-dynamic-scheduler-condor"],
  }
  
  file { "$gippath/plugin/glite-info-dynamic-scheduler-wrapper":
    ensure  => present,
    owner   => "${info_user}",
    group   => "${info_group}",
    mode    => '0755',
    content => template("creamce/gip/glite-info-dynamic-scheduler-wrapper.erb"),
    require => File["/etc/lrms/scheduler.conf"],
    notify  => Service["bdii"],
  }
  
  file { "$gippath/plugin/glite-info-dynamic-ce":
    ensure  => present,
    owner   => "${info_user}",
    group   => "${info_group}",
    mode    => '0755',
    content => "#!/bin/sh\n/usr/libexec/glite-info-dynamic-condor /etc/lrms/condor.conf\n",
    require => File["/etc/lrms/condor.conf"],
    notify  => Service["bdii"],
  }
  
  # ##################################################################################################
  # Condor client
  # ##################################################################################################
  
  if $cream_config_ssh {
    
      class { 'creamce::sshconfig':
        lrms_host_script => "echo "
      }

  }

}
