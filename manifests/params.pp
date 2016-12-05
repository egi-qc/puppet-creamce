class creamce::params {
  $sitename                  = hiera("creamce::site::name", "${::fqdn}")
  $siteemail                 = hiera("creamce::site::email", "")
  $ce_host                   = hiera("creamce::host", "${::fqdn}")
  $ce_port                   = hiera('creamce::port', 8443)
  $ce_type                   = hiera('creamce::type', "cream")
  $ce_quality_level          = hiera('creamce::quality_level', "production")
  $ce_env                    = hiera('creamce::environment', {})
  $access_by_domain          = hiera("creamce::mysql::access_by_domain", false)
  
  $mysql_override_options    = hiera("creamce::mysql::override_options", {
                                         'mysqld' => {
                                             'bind-address' => '0.0.0.0',
                                             'max_connections' => "450"
                                          }})
  $mysql_password            = hiera("creamce::mysql::root_password")
  $cream_db_max_active       = hiera("creamce::mysql::max_active", 200)
  $cream_db_min_idle         = hiera("creamce::mysql::min_idle", 30)
  $cream_db_max_wait         = hiera("creamce::mysql::max_wait", 10000)
  $cream_db_name             = hiera("creamce::creamdb::name", "creamdb")
  $cream_db_user             = hiera("creamce::creamdb::user", "cream")
  $cream_db_password         = hiera("creamce::creamdb::password")
  $cream_db_host             = hiera("creamce::creamdb::host", "${::fqdn}")
  $cream_db_port             = hiera("creamce::creamdb::port", 3306)
  $cream_db_domain           = hiera("creamce::creamdb::domain", "${::domain}")
  $cream_db_minpriv_user     = hiera("creamce::creamdb::minpriv_user", "minprivuser")
  $cream_db_minpriv_password = hiera("creamce::creamdb::minpriv_password")
  $delegation_db_name        = hiera("creamce::delegationdb::name", "delegationcreamdb")

  $cream_db_sandbox_path     = hiera("creamce::sandbox_path", "/var/cream_sandbox")
  $cream_enable_limiter      = hiera("creamce::enable_limiter", true)
  $cream_limit_load1         = hiera("creamce::limit::load1", 400)
  $cream_limit_load5         = hiera("creamce::limit::load5", 400)
  $cream_limit_load15        = hiera("creamce::limit::load15", 200)
  $cream_limit_memusage      = hiera("creamce::limit::memusage", 95)      
  $cream_limit_swapusage     = hiera("creamce::limit::swapusage", 95)      
  $cream_limit_fdnum         = hiera("creamce::limit::fdnum", 5000)      
  $cream_limit_diskusage     = hiera("creamce::limit::diskusage", 95)      
  $cream_limit_ftpconn       = hiera("creamce::limit::ftpconn", 500)      
  $cream_limit_fdtomcat      = hiera("creamce::limit::fdtomcat", 8000)      
  $cream_limit_activejobs    = hiera("creamce::limit::activejobs", -1)      
  $cream_limit_pendjobs      = hiera("creamce::limit::pendjobs", -1)
  $cream_queue_size          = hiera("creamce::queue_size", 500)
  $cream_workerpool_size     = hiera("creamce::workerpool_size", 50)
  $cream_blah_timeout        = hiera("creamce::blah_timeout", 300)
  $cream_listener_port       = hiera("creamce::listener_port", 49152)
  $cream_job_purge_rate      = hiera("creamce::job_purge_rate", 300)
  $cream_blp_retry_delay     = hiera("creamce::blp::retry_delay", 60)
  $cream_blp_retry_count     = hiera("creamce::blp::retry_count", 100)
  $cream_lease_time          = hiera("creamce::lease::time", 36000)
  $cream_lease_rate          = hiera("creamce::lease::rate", 30)
  $cream_purge_aborted       = hiera("creamce::purge::aborted", 10)
  $cream_purge_cancel        = hiera("creamce::purge::cancel", 10)
  $cream_purge_done          = hiera("creamce::purge::done", 10)
  $cream_purge_failed        = hiera("creamce::purge::failed", 10)
  $cream_purge_register      = hiera("creamce::purge::register", 2)
  
  $deleg_purge_rate          = hiera("creamce::delegation::purge_rate", 720)
  
  $jw_deleg_time_slot        = hiera("creamce::jw::deleg_time_slot", 3600)
  $jw_proxy_retry_wait       = hiera("creamce::jw::proxy_retry_wait", 60)
  $jw_retry_count_isb        = hiera("creamce::jw::retry::count_isb", 2)
  $jw_retry_wait_isb         = hiera("creamce::jw::retry::wait_isb", 60)
  $jw_retry_count_osb        = hiera("creamce::jw::retry::count_osb", 6)
  $jw_retry_wait_osb         = hiera("creamce::jw::retry::wait_osb", 300)

  $gridenvfile               = hiera('creamce::gridenvfile::sh','/etc/profile.d/grid-env.sh')
  $gridenvcfile              = hiera('creamce::gridenvfile::csh','/etc/profile.d/grid-env.csh')
  
  $cga_logfile               = hiera("creamce::cga::logfile", "/var/log/cleanup-grid-accounts.log")
  $cga_cron_sched            = hiera("creamce::cga::cron_sched", "30 1 * * *")
  $at_deny_extras            = hiera("creamce::at_deny_extras", [])
  $cron_deny_extras          = hiera("creamce::cron_deny_extras", [])
  $sudo_logfile              = hiera("creamce::sudo_logfile", "")
  $default_pool_size         = hiera("creamce::default_pool_size", 100)

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
  $catalina_home             = hiera('creamce::catalina::home', "/usr/share/$tomcat")
  $tomcat_server_lib         = hiera('creamce::catalina::server_lib', "${catalina_home}/lib")
  $tomcat_cert               = hiera('creamce::tomcat::cert', '/etc/grid-security/tomcat-cert.pem')
  $tomcat_key                = hiera('creamce::tomcat::key', '/etc/grid-security/tomcat-key.pem')
  $java_opts                 = hiera('creamce::java_opts','-Xms512m -Xmx2048m')

  
  #
  # BLAH/LRMS
  #
  $batch_system              = hiera("creamce::batch_system")
  $blah_config_file          = hiera("blah::config_file", "/etc/blah.config")
  $blah_child_poll_timeout   = hiera("blah::child_poll_timeout", 200)
  $blah_alldone_interval     = hiera("blah::alldone_interval", 86400)
  $use_blparser              = hiera("blah::use_blparser", false)
  $blah_blp_server           = hiera("blah::blp::host", "")
  $blah_blp_port             = hiera("blah::blp::port", 33333)
  $blah_blp_num              = hiera("blah::blp::num", 1)
  $blah_blp_server1          = hiera("blah::blp::host1", "${blah_blp_server}")
  $blah_blp_port1            = hiera("blah::blp::port1", 33334)
  $blah_blp_server2          = hiera("blah::blp::host2", "${blah_blp_server}")
  $blah_blp_port2            = hiera("blah::blp::port2", 33335)
  $blah_blp_cream_port       = hiera("blah::blp::cream_port", 56565)
  $blah_check_children       = hiera("blah::check_children", 30)
  $blah_logrotate_interval   = hiera("blah::logrotate::interval", 365)
  $blah_logrotate_size       = hiera("blah::logrotate::size", "10M")
  $bupdater_loop_interval    = hiera("blah::bupdater::loop_interval", 30)
  $bupdater_notify_port      = hiera("blah::bupdater::notify_port", 56554)
  $bupdater_purge_interval   = hiera("blah::bupdater::purge_interval", 2500000)
  $bupdater_logrot_interval  = hiera("blah::bupdater::logrotate::interval", 50)
  $bupdater_logrot_size      = hiera("blah::bupdater::logrotate::size", "10M")
  
  $torque_config_client      = hiera("torque::config::client", true)
  $torque_config_ssh         = hiera("torque::config::ssh", true)
  $torque_config_pool        = hiera("torque::config::pool", true)
  $torque_server             = hiera("torque::host", "${::fqdn}")
  $torque_log_dir            = hiera("torque::log_dir", "/var/lib/torque/")
  $torque_multiple_staging   = hiera("torque::multiple_staging", false)
  $torque_tracejob_logs      = hiera("torque::tracejob_logs", 2)
  $torque_use_maui           = hiera("torque::use_maui", false)
  $torque_sched_opts         = hiera("torque::sched_opts", { "cycle_time" => "0" })
  $torque_ssh_cron_sched     = hiera("torque::ssh_cron_sched", "05 1,7,13,19 * * *")
  $torque_caching_filter     = hiera("torque::command_caching_filter", "")
  $munge_key_path            = hiera("munge::key_path", "")

  $lsf_primary_master        = hiera("lsf::primary_master", undef)
  $lsf_secondary_master      = hiera("lsf::secondary_master", undef)
  $lsf_caching_filter        = hiera("lsf::command_caching_filter", "")
  $lsf_conf_afs_path         = hiera("lsf::conf_afs_path", undef)

  $slurm_config_ssh          = hiera("slurm::config_ssh", true)
  $slurm_sched_opts          = hiera("slurm::sched_opts", { "cycle_time" => "0" })
  $slurm_caching_filter      = hiera("slurm::command_caching_filter", "")
  
  $condor_sched_opts         = hiera("condor::sched_opts", { "cycle_time" => "0" })
  $condor_caching_filter     = hiera("condor::command_caching_filter", "")
  $condor_user_history       = hiera("condor::use_history", false)
  $condor_deploy_mode        = hiera("condor::deployment_mode", "queue_to_schedd")
  $condor_queue_attr         = hiera("condor::queue_attribute", undef)

  $shosts_equiv_extras       = hiera("shosts_equiv_extras", [])



  #
  # LCAS/LCMAPS/GLEXEC
  #
  $lcas_log_level          = hiera('lcas::log_level', 1)
  $lcas_debug_level        = hiera('lcas::debug_level', 0)
  $lcmaps_log_level        = hiera('lcmaps::log_level', 1)
  $lcmaps_debug_level      = hiera('lcmaps::debug_level', 0)
  $lcmaps_rotate_size      = hiera("lcmaps::rotate::size", "10M")
  $lcmaps_rotate_num       = hiera("lcmaps::rotate::num", 50)
  $glexec_rotate_size      = hiera("glexec::rotate::size", "10M")
  $glexec_rotate_num       = hiera("glexec::rotate::num", 50)
  $glexec_log_file         = hiera("glexec::log_file", "")
  $glexec_log_level        = hiera("glexec::log_level", 1)
  $glexec_ll_log_file      = hiera("glexec::low_level_log_file", "/var/log/glexec/lcas_lcmaps.log")
  
  #
  # GridFTP
  #
  $gridftp_host              = hiera("gridftp::params::hostname", "${::fqdn}")
  $gridftp_port              = hiera("gridftp::params::port", 2811)
  $gridft_pub_dir            = hiera('gridftp_pub_dir', '/var/info')
  $globus_tcp_port_range     = hiera("gridftp::params::globus_tcp_port_range", "20000,25000")
  $globus_udp_port_range     = hiera("gridftp::params::globus_udp_port_range", undef)
  $gridftp_configfile        = hiera("gridftp::params::configfile", "/etc/gridftp.conf")
  $gridftp_configdir         = hiera("gridftp::params::configdir", "/etc/gridftp.d")
  $gridftp_thread_model      = hiera("gridftp::params::thread_model", undef)
  $gridftp_force_tls         = hiera("gridftp::params::force_tls", 1)
  $gridftp_extra_vars        = hiera("gridftp_extra_vars", {})
  
  #
  # Security
  #
  $host_certificate        = hiera('creamce::host_certificate','/etc/grid-security/hostcert.pem')
  $host_private_key        = hiera('creamce::host_private_key','/etc/grid-security/hostkey.pem')
  $cacert_dir              = hiera('creamce::cacert_dir','/etc/grid-security/certificates')
  $voms_dir                = hiera('creamce::voms_dir','/etc/grid-security/vomsdir')
  $gridmap_dir             = hiera('creamce::gridmap_dir','/etc/grid-security/gridmapdir')
  $gridmap_file            = hiera('creamce::gridmap_file','/etc/grid-security/grid-mapfile')
  $gridmap_extras          = hiera("creamce::gridmap_extras", [])
  $gridmap_cron_sched      = hiera("creamce::gridmap_cron_sched", "5 * * * *")
  $groupmap_file           = hiera('creamce::groupmap_file','/etc/grid-security/groupmapfile')
  $groupmap                = hiera('creamce::groupmap',undef)
  $crl_update_time         = hiera('creamce::crl_update_time',3600)
  $cream_ban_list_file     = hiera('creamce::ban_list_file', '/etc/lcas/ban_users.db')
  $use_argus               = hiera("creamce::use_argus", true)
  $argusservice            = hiera("creamce::argus::service", undef)
  $argusport               = hiera("creamce::argus::port", 8154)
  $argus_timeout           = hiera("creamce::argus::timeout", 30)
  $cream_pepc_resourceid   = hiera('creamce::resourceid',"https://${ce_host}:${ce_port}/cream")
  $admin_list              = hiera('creamce::admin::list', [])
  $cream_admin_list_file   = hiera('creamce::admin::list_file', '/etc/grid-security/admin-list')
  $voenv                   = hiera('creamce::vo_table', {})


  #
  # Infosystem
  #
  $info_user               = hiera("bdii::params::user", "ldap")
  $info_group              = hiera("bdii::params::group", "ldap")
  $info_port               = hiera('bdii::params::port', 2170)
  $subclusters             = hiera('creamce::hardware_table', {})
  $clustermode             = hiera('creamce::cluster_mode', false)
  $glue_2_1                = hiera('creamce::info::glue21_draft', false)
  $gippath                 = hiera('creamce::info::gip_path', "/var/lib/bdii/gip")
  $info_type               = hiera('creamce::info::type', "resource")
  $ce_capability           = hiera('creamce::info::capability', [])
  $computing_service_id    = hiera('creamce::info::service_id', "${ce_host}_ComputingElement")
  $se_list                 = hiera('creamce::se_table', {})
  $grid_queues             = hiera('creamce::queues', {})
  $workarea_shared         = hiera('creamce::workarea::shared', false)
  $workarea_guaranteed     = hiera('creamce::workarea::guaranteed', false)
  $workarea_total          = hiera('creamce::workarea::total', 0)
  $workarea_free           = hiera('creamce::workarea::free', 0)
  $workarea_lifetime       = hiera('creamce::workarea::lifetime', 0)
  $workarea_mslot_total    = hiera('creamce::workarea::mslot_total', 0)
  $workarea_mslot_free     = hiera('creamce::workarea::mslot_free', 0)
  $workarea_mslot_lifetime = hiera('creamce::workarea::mslot_lifetime', 0)
  $applications            = hiera('creamce::software_table', {})
  
  #
  # Locallogger
  #
  $use_loclog                 = hiera('creamce::use_locallogger', true)
  $loclog_user                = hiera('locallogger::user', 'glite')
  $loclog_group               = hiera('locallogger::group', 'glite')
  $loclog_dir                 = hiera('locallogger::dir', '/var/lib/glite')

  #
  # apel accounting secrets
  #
  $apel_dbname                = hiera('apel::db::name','unset')
  $apel_dbpass                = hiera('apel::db::pass')
  $apel_dbserv                = hiera('apel::db::host','unset')

  #
  # yum repositories
  #
  $cream_repo_urls            = hiera('creamce::repo_urls', [])

}
