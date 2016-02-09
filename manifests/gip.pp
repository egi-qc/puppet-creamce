class creamce::gip inherits creamce::params {

  #
  # common plugin 
  #

  include creamce::gip::plugin::glite_info_cream_glue2

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
    # plugin
    include creamce::gip::plugin::glite_info_provider_service_cream_wrapper
    # provider
    include creamce::gip::provider::glite_info_provider_service_cream_wrapper
    exec {'ComputingShare.ldif.dummy':
      command => "/bin/touch  /var/lib/bdii/gip/ldif/ComputingShare.ldif"
    }  
    exec {'ComputingManager.ldif.dummy':
      command => "/bin/touch  /var/lib/bdii/gip/ldif/ComputingManager.ldif"
    }  
  }
  else
  {
    
    include creamce::gip::plugin::glite_info_dynamic_software_wrapper
    
    #
    # providers
    #
    include creamce::gip::provider::glite_info_glue2_applicationenvironment_wrapper
    include creamce::gip::provider::glite_info_provider_service_rtepublisher_wrapper

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
