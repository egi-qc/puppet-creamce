class creamce::params {
  $sitename                  = hiera("site_name", "${::fqdn}")
  $siteemail                 = hiera("site_email", "")
  $ce_host                   = hiera("ce_host", "${::fqdn}")
  $ce_port                   = hiera('ce_port', "8443")
  $ce_type                   = hiera('ce_type', "cream")
  $ce_quality_level          = hiera('ce_quality_level', "production")
  $ce_env                    = hiera('ce_env', {})
  $access_by_domain          = hiera("access_by_domain", "false")
  
  $max_connections           = hiera("max_connections", "999")
  $mysql_password            = hiera("mysql_password")
  $cream_db_name             = hiera("cream_db_name", "creamdb")
  $cream_db_user             = hiera("cream_db_user", "cream")
  $cream_db_password         = hiera("cream_db_password")
  $cream_db_host             = hiera("cream_db_host", "${::fqdn}")
  $cream_db_port             = hiera("cream_db_port", "3306")
  $cream_db_domain           = hiera("cream_db_domain", "${::domain}")
  $cream_db_minpriv_user     = hiera("cream_db_minpriv_user", "minprivuser")
  $cream_db_minpriv_password = hiera("cream_db_minpriv_password")
  $cream_db_max_active       = hiera("cream_db_max_active", "200")
  $cream_db_min_idle         = hiera("cream_db_min_idle", "30")
  $cream_db_max_wait         = hiera("cream_db_max_wait", "10000")
  $delegation_db_name        = hiera("delegation_db_name", "delegationcreamdb")

  $cream_db_sandbox_path     = hiera("cream_db_sandbox_path", "/var/cream_sandbox")
  $cream_enable_limiter      = hiera("cream_enable_limiter", "true")
  $cream_limit_load1         = hiera("cream_limit_load1", "400")
  $cream_limit_load5         = hiera("cream_limit_load5", "400")
  $cream_limit_load15        = hiera("cream_limit_load15", "200")
  $cream_limit_memusage      = hiera("cream_limit_memusage", "95")      
  $cream_limit_swapusage     = hiera("cream_limit_swapusage", "95")      
  $cream_limit_fdnum         = hiera("cream_limit_fdnum", "5000")      
  $cream_limit_diskusage     = hiera("cream_limit_diskusage", "95")      
  $cream_limit_ftpconn       = hiera("cream_limit_ftpconn", "500")      
  $cream_limit_fdtomcat      = hiera("cream_limit_fdtomcat", "8000")      
  $cream_limit_activejobs    = hiera("cream_limit_activejobs", "-1")      
  $cream_limit_pendjobs      = hiera("cream_limit_pendjobs", "-1")
  $cream_queue_size          = hiera("cream_queue_size", "500")
  $cream_workerpool_size     = hiera("cream_workerpool_size", "50")
  $cream_blah_timeout        = hiera("cream_blah_timeout", "300")
  $cream_listener_port       = hiera("cream_listener_port", "49152")
  $cream_job_purge_rate      = hiera("cream_job_purge_rate", "300")
  $cream_blp_retry_delay     = hiera("cream_blp_retry_delay", "60000")
  $cream_blp_retry_count     = hiera("cream_blp_retry_count", "100")
  $cream_lease_time          = hiera("cream_lease_time", "36000")
  $cream_lease_rate          = hiera("cream_lease_rate", "30")
  $cream_smp_size            = hiera("cream_smp_size", "8")
  $cream_purge_aborted       = hiera("cream_purge_aborted", "10")
  $cream_purge_cancel        = hiera("cream_purge_cancel", "10")
  $cream_purge_done          = hiera("cream_purge_done", "10")
  $cream_purge_failed        = hiera("cream_purge_failed", "10")
  $cream_purge_register      = hiera("cream_purge_register", "2")
  
  $deleg_purge_rate          = hiera("deleg_purge_rate", "720")
  
  $jw_deleg_time_slot        = hiera("jw_deleg_time_slot", "3600")
  $jw_proxy_retry_wait       = hiera("jw_proxy_retry_wait", "60")
  $jw_retry_count_isb        = hiera("jw_retry_count_isb", "2")
  $jw_retry_wait_isb         = hiera("jw_retry_wait_isb", "60")
  $jw_retry_count_osb        = hiera("jw_retry_count_osb", "6")
  $jw_retry_wait_osb         = hiera("jw_retry_wait_osb", "300")

  $gridenvfile               = hiera('gridenvfile','/etc/profile.d/grid-env.sh')
  
  $cga_logfile               = hiera("cga_logfile", "/var/log/cleanup-grid-accounts.log")
  $cga_cron_sched            = hiera("cga_cron_sched", "30 1 * * *")
  $at_deny_extras            = hiera("at_deny_extras", [])
  $cron_deny_extras          = hiera("cron_deny_extras", [])

  #
  # Tomcat
  #
  case $::lsbmajdistrelease {
    6: {
      $tomcat                = "tomcat6"
    }
    default: {
      $tomcat                = "tomcat"
    }
  }
  $catalina_home             = hiera('catalina_home', "/usr/share/$tomcat")
  $tomcat_server_lib         = "${catalina_home}/lib"
  $tomcat_cert               = hiera('tomcat_cert', '/etc/grid-security/tomcat-cert.pem')
  $tomcat_key                = hiera('tomcat_key', '/etc/grid-security/tomcat-key.pem')
  $java_opts                 = hiera('java_opts','-Xms512m -Xmx2048m')

  
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
  $blah_logrotate_interval   = hiera("blah_logrotate_interval", "365")
  $blah_logrotate_size       = hiera("blah_logrotate_size", "10M")
  $bupdater_logrot_interval  = hiera("bupdater_logrot_interval", "50")
  $bupdater_logrot_size      = hiera("bupdater_logrot_size", "10M")
  
  $torque_log_dir            = hiera("torque_log_dir", "/var/lib/torque/")
  $torque_multiple_staging   = hiera("torque_multiple_staging","false")
  $torque_tracejob_logs      = hiera("torque_tracejob_logs", "2")

  $lsf_primary_master        = hiera("lsf_primary_master", undef)
  $lsf_secondary_master      = hiera("lsf_secondary_master", undef)
  $lsf_conf_afs_path         = hiera("lsf_conf_afs_path", undef)



  #
  # LCAS/LCMAPS/GLEXEC
  #
  $lcmaps_log_level        = hiera('lcmaps_log_level','1')
  $lcmaps_debug_level      = hiera('lcmaps_debug_level','0')
  $lcas_log_level          = hiera('lcas_log_level','1')
  $lcas_debug_level        = hiera('lcas_debug_level','0')
  $lcmaps_rotate_size      = hiera("lcmaps_rotate_size", "10M")
  $lcmaps_rotate_num       = hiera("lcmaps_rotate_num", "50")
  $glexec_rotate_size      = hiera("glexec_rotate_size", "10M")
  $glexec_rotate_num       = hiera("glexec_rotate_num", "50")
  
  #
  # GridFTP
  #
  $gridftp_port              = hiera("gridftp::params::port", "2811")
  $globus_tcp_port_range     = hiera("gridftp::params::globus_tcp_port_range", "20000,25000")
  
  
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
  $groupmap                = hiera('groupmap',undef)
  $crl_update_millis       = hiera('crl_update_millis',3600000)
  $cream_admin_list_file   = hiera('cream_admin_list_file', '/etc/grid-security/admin-list')
  $cream_ban_list_file     = hiera('cream_ban_list_file', '/etc/lcas/ban_users.db')
  $use_argus               = hiera("use_argus", "true")
  $argusservice            = hiera("argusservice", undef)
  $argusport               = hiera("argusport", "8154")
  $cream_pepc_resourceid   = hiera('cream_pepc_resourceid','http://${cream_db_host}:${ce_port}/cream')
  $admin_list              = hiera('admin_list', [])
  $voenv                   = hiera('voenv', {})


  #
  # Infosystem
  #
  $info_user               = hiera("bdii::params::user","ldap")
  $info_group              = hiera("bdii::params::group","ldap")
  $clusters                = hiera('clusters','unset')
  $subclusters             = hiera('subclusters','unset')
  $ce_def                  = hiera('ce_def','unset')
  $clustermode             = hiera('clustermode', "false")
  $clusterid               = hiera('clusterid', undef)
  $gippath                 = hiera('gippath', "/var/lib/bdii/gip")
  $info_port               = hiera('info_port', "2170")
  $info_type               = hiera('info_type', "resource")
  $ce_capability           = hiera('ce_capability', [])
  $computing_service_id    = hiera('computing_service_id', "${ce_host}_ComputingElement")
  $se_list                 = hiera('se_list', {})
  $grid_queues             = hiera('grid_queues', {})
  $workarea_shared         = hiera('workarea_shared', 'false')
  $workarea_guaranteed     = hiera('workarea_guaranteed', 'false')
  $workarea_total          = hiera('workarea_total', 0)
  $workarea_free           = hiera('workarea_free', 0)
  $workarea_lifetime       = hiera('workarea_lifetime', 0)
  $workarea_mslot_total    = hiera('workarea_mslot_total', 0)
  $workarea_mslot_free     = hiera('workarea_mslot_free', 0)
  $workarea_mslot_lifetime = hiera('workarea_mslot_lifetime', 0)
  $gridft_pub_dir          = hiera('gridftp_pub_dir', '/opt/glite/var/info')
  
  #
  # Locallogger
  #
  $loclog_user                = hiera('locallogger_user', 'glite')
  $loclog_group               = hiera('locallogger_group', 'glite')
  $loclog_dir                 = hiera('locallogger_dir', '/var/lib/glite')

  # wrong! this is CE specific
  $cores                      = hiera('cores','0')           
  $benchmark_info             = hiera('benchmark_info','((specfp2000 0), (specint2000 0), (HEP-SPEC06 0))') # 
  
  #
  # apel accounting secrets
  #
  $apel_dbname                = hiera('apel_dbname','unset')
  $apel_dbpass                = hiera('apel_dbpass')
  $apel_dbserv                = hiera('apel_dbserv','unset')

  #
  # yum repositories
  #
  $cream_repo_url             = hiera('cream_repo_url', '')
  $cream_repo                 = hiera('cream_repo_file', '/etc/yum.repos.d/creamce.repo')

}
