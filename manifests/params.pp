class creamce::params {
  $sitename                  = hiera("sitename","")
  $max_connections           = hiera("max_connections","999")
  $mysql_password            = hiera("mysql_password")
  $cream_db_name             = hiera("cream_db_name"            ,"creamdb")
  $cream_db_user             = hiera("cream_db_user"            ,"cream")
  $cream_db_password         = hiera("cream_db_password")
  $cream_db_host             = hiera("cream_db_host"            ,"${::fqdn}")
  $cream_db_domain           = hiera("cream_db_domain"          ,"${::domain}")
  $cream_db_sandbox_path     = hiera("cream_db_sandbox_path"    ,"/var/cream_sandbox")
  $cream_db_minpriv_user     = hiera("cream_db_minpriv_user"    ,"minprivuser")
  $cream_db_minpriv_password = hiera("cream_db_minpriv_password")
  $cream_db_version          = hiera("cream_db_version"         ,"2.6")
  $access_by_domain          = hiera("access_by_domain"         ,"false")
  $delegation_db_name        = hiera("delegation_db_name"       ,"delegationcreamdb")
  $delegation_db_version     = hiera("delegation_db_version","2.6")
  $interface_version         = hiera("interface_version  ","2.1")
  $supported_vos             = hiera("supported_vos",undef)
  $argusservice              = hiera("argusservice",undef)
  $argusport                 = hiera("argusport","8154")
  $information_db_name       = hiera("information_db_name","information_schema")

  $gridenvfile               = hiera('gridenvfile','/etc/profile.d/grid-env.sh')
  $ce_env                    = hiera('ce_env',{})
  $cream_pepc_resourceid     = hiera('cream_pepc_resourceid','http://emi.cern.ch/cream')
  $admin_list                = hiera('admin_list',"")
  $grid_queues               = hiera('grid_queues')
  $voenv                     = hiera('voenv')
  $computing_service_id      = hiera('computing_service_id')
  $clusterid                 = hiera('clusterid')
  $clustermode               = hiera('clustermode')
  case $::lsbmajdistrelease {
    6: {
      $tomcat                = "tomcat6"
    }
    default: {
      $tomcat                = "tomcat"
    }
  }
  $catalina_home           = hiera('catalina_home',"/usr/share/$tomcat")
  $tomcat_server_lib       = "${catalina_home}/lib"
  $gippath                 = hiera('gippath',"/var/lib/bdii/gip")
  $ce_port                 = hiera('ce_port',"8443")
  $ce_type                 = hiera('ce_type',"cream")
  $ce_impl_ver             = hiera('ce_impl_ver',"unset") # fixme
  $info_port               = hiera('info_port',"2170")
  $info_type               = hiera('info_type',"resource")
  $ce_capability           = hiera('ce_capability',[])
  $groupmap                = hiera('groupmap',undef)
  $se_list                 = hiera('se_list',undef)
  
  #
  # BLAH/LRMS
  #
  $batch_system              = hiera("batch_system", undef)
  $blah_child_poll_timeout   = hiera("blah_child_poll_timeout", "200")
  $blah_alldone_interval     = hiera("blah_alldone_interval", "86400")
  $blparser_with_updater     = hiera("blparser_with_updater", "true")
  $blah_blp_server           = hiera("blah_blp_server", undef)
  $blah_blp_port             = hiera("blah_blp_port", "33333")
  $blah_blp_num              = hiera("blah_blp_num", undef)
  $blah_blp_server1          = hiera("blah_blp_server1", "${blah_blp_server}")
  $blah_blp_port1            = hiera("blah_blp_port1", "33334")
  $blah_blp_server2          = hiera("blah_blp_server2", "${blah_blp_server}")
  $blah_blp_port2            = hiera("blah_blp_port2", "33335")
  $bupdater_loop_interval    = hiera("bupdater_loop_interval", "30")
  $bupdater_notify_port      = hiera("bupdater_notify_port", "56554")
  $bupdater_purge_interval   = hiera("bupdater_purge_interval", "2500000")
  $blah_check_children       = hiera("blah_check_children", "30")
  
  $torque_log_dir            = hiera("torque_log_dir", "/var/lib/torque/")
  $torque_multiple_staging   = hiera("torque_multiple_staging","false")
  $torque_tracejob_logs      = hiera("torque_tracejob_logs", "2")

  $lsf_primary_master        = hiera("lsf_primary_master", undef)
  $lsf_secondary_master      = hiera("lsf_secondary_master", undef)
  $lsf_conf_afs_path         = hiera("lsf_conf_afs_path", undef)



  #
  # LCAS/LCMAPS
  #
  $lcmaps_log_level        = hiera('lcmaps_log_level','1')
  $lcmaps_debug_level      = hiera('lcmaps_debug_level','0')
  $lcas_log_level          = hiera('lcas_log_level','1')
  $lcas_debug_level        = hiera('lcas_debug_level','0')
  
  #
  # GridFTP
  #
  $gridftp_port              = hiera('gridftp_port',"2811")
  $gridftp_connections_max   = hiera('gridftp_connections_max',"150")
  $globus_tcp_port_range     = hiera('globus_tcp_port_range',"20000,25000")
  
  
  #
  # Security
  #
  $host_certificate        = hiera('host_certificate','/etc/grid-security/hostcert.pem')
  $host_private_key        = hiera('host_private_key','/etc/grid-security/hostkey.pem')
  $cacert_dir              = hiera('cacert_dir','/etc/grid-security/certificates')
  $voms_dir                = hiera('voms_dir','/etc/grid-security/vomsdir')
  $gridmap_dir             = hiera('gridmap_dir','/etc/grid-security/gridmapdir')
  $gridmap_file            = hiera('gridmap_file','/etc/grid-security/grid-mapfile')
  $groupmap_file           = hiera('groupmap_file','/etc/grid-security/groupmapfile')
  $crl_update_millis       = hiera('crl_update_millis',3600000)
  
  #
  # execution environment static info
  #
  # fixme
  $execution_environments   = hiera('execution_environments',[$::fqdn])

  # wrong! this is CE specific
  $cores                      = hiera('cores','0')           
  $benchmark_info             = hiera('benchmark_info','((specfp2000 0), (specint2000 0), (HEP-SPEC06 0))') # 
  $java_opts                  = hiera('java_opts','-Xms512m -Xmx2048m')
  
# structure of the site
  $clusters                   = hiera('clusters','unset')
  $subclusters                = hiera('subclusters','unset')
  $ce_def                     = hiera('ce_def','unset')
  
  #
  # apel accounting secrets
  #
  $apel_dbname                = hiera('apel_dbname','unset')
  $apel_dbpass                = hiera('apel_dbpass')
  $apel_dbserv                = hiera('apel_dbserv','unset')

  #
  # nfs settings
  #
  $nfs_server_cachedir        = hiera('nfs_server_cachedir',unset)
  $nfs_server_infodir         = hiera('nfs_server_infodir',unset)
  $nfs_remote_cachedir        = hiera('nfs_remote_cachedir',unset)
  $nfs_remote_infodir         = hiera('nfs_remote_infodir',unset)
  $nfs_options                = hiera('nfs_options',unset)
}
