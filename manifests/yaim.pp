class creamce::yaim inherits creamce::params {
  #
  # obsolete since 4/6/2013
  #

  exec {"yaim":
    command => '/bin/echo /opt/glite/yaim/bin/yaim -c -s /etc/siteinfo.def -n creamCE -n LSF_utils'
  }
  
  # let some parts be configured by yaim. This is just a stop-gap solution and should be reduced to the bare minimum
  #
  
  $disabledfunctions = [
                        'config_cream_remove_subcluster_ce',
                        'config_cream_cemon',
                        'config_gip_sched_plugin_lsf', 
                        'config_cream_info_service_rtepublish',
                        'config_info_service_cream_ce',
                        'config_info_service_cemon',
                        'config_info_service_cemon',
                        'config_cream_gip_info_dynamic',
                        'config_cream_gip',
                        'config_cream_gip_glue2',
                        'config_cream_gip_scheduler_plugin',
                        'config_cream_gip_software_plugin',
                        'config_gip_sched_plugin_lsf',
                        'config_cream_start',
                        'config_cream_stop',
                        'config_cream_detect_tomcat',
                        'config_secure_tomcat',
                        'config_cream_gliteservices',
                        'config_cream_glite_initd',
                        'config_cream_emies_scratch_reinstall',
                        'config_cream_emies_db',
                        'config_cream_emies',
                        'config_add_pool_env',
                        'config_cream_logrotation',                        
                        'config_ldconf',
                        'config_cream_sudoers_check',
                        'config_cream_sudoers',
                        'config_cream_glexec',
                        'config_cream_glexec_user',
                        'config_sysconfig_edg',
                        'config_cream_ce',
                        'config_cream_blah',
                        'config_crl',
                        'config_host_certs',
                        'config_users',
                        'config_edgusers',
                        'config_vomsmap',
                        'config_vomses',
                        'config_vomsdir',
                        'config_globus_gridftp',
                        'config_bdii_5.2',
                        'config_cream_db',
                        'config_cream_vo_tag_dir',
                        'config_check_lsf_installation',
                        'config_lcas_lcmaps_gt4',
                        'config_cream_locallogger',
                        'config_glite_locallogger',
                        'config_check_lsf_installation',
                        ]
  
  $disabled_functions_hash=parseyaml(inline_template("{ <%= @disabledfunctions.collect{ |name| name + ': {}' }.join(', ') %>} "))
  create_resources("creamce::yaim_disabledfunction",$disabled_functions_hash,{notify => Exec["yaim"]})
  
  file{"/etc/siteinfo.def":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0644,
    content => template("creamce/siteinfo.def.erb"),
  }
  
  File["/etc/siteinfo.def"] -> Exec["yaim"]  
}
