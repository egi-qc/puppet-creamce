class creamce::slurm inherits creamce::params {

  include creamce::blah
  include creamce::gip
  include creamce::poolaccount
  
  $vo_group_table = build_vo_group_table($voenv)
  
  # ##################################################################################################
  # BLAHP setup
  # ##################################################################################################

  file{"${blah_config_file}":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => '0644',
    content => template("creamce/blah.config.slurm.erb"),
  }

  # ##################################################################################################
  # SLURM infoproviders
  # ##################################################################################################

  package{"info-dynamic-scheduler-slurm":
    ensure  => present,
    require => Package["dynsched-generic"],
    tag     => [ "bdiipackages", "umdpackages" ],
  }

  file { "/etc/lrms/scheduler.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => '0644',
    content => template("creamce/gip/slurm-provider.conf.erb"),
    require => Package["info-dynamic-scheduler-slurm"],
    notify  => Service["bdii"],
  }

  # ##################################################################################################
  # SLURM client
  # ##################################################################################################
  
  if $cream_config_ssh {
    
    class { 'creamce::sshconfig':
      lrms_host_script => "/usr/bin/scontrol -o show nodes | grep -Eo 'NodeHostName=(\\S+)' | cut -d \"=\" -f 2",
      lrms_master_node => $slurm_master
    }

  }

  define slurm_user ($pool_user, $accounts, $partitions) {

    $partstr = join($partitions, ",")
    $acctstr = join($accounts, ",")

    exec { "${title}":
      command => "/usr/bin/sacctmgr -i create user name=${pool_user} account=${acctstr} partition=${partstr}",
      unless  => "/usr/bin/sacctmgr -p -n show user ${pool_user} | grep ${pool_user}",
    }
    
  }

  define slurm_top_account ($acct) {
    
    exec { "${title}":
      command => "/usr/bin/sacctmgr -i create account name=${acct} description=\"VO ${acct}\" organization=grid",
      unless  => "/usr/bin/sacctmgr -p -n show account ${acct} | grep ${acct}",
    }

  }
  
  define slurm_sub_account ($acct, $p_acct) {

    exec { "${title}":
      command => "/usr/bin/sacctmgr -i create account name=${acct} parent=${p_acct} description=\"VO Group ${acct}\" organization=grid",
      unless  => "/usr/bin/sacctmgr -p -n show account ${acct} | grep ${acct}",
    }
    
  }
  
  if $slurm_config_acct {

    $slurm_acct_users = build_slurm_users($voenv, $grid_queues,
                                          $default_pool_size, $slurm_use_std_acct, $username_offset)
    create_resources(slurm_user, $slurm_acct_users)

    if $slurm_use_std_acct {

      $top_slurm_accts = build_slurm_accts($voenv, "top")
      create_resources(slurm_top_account, $top_slurm_accts)

      $sub_slurm_accts = build_slurm_accts($voenv, "sub")
      create_resources(slurm_sub_account, $sub_slurm_accts)
      
      Creamce::Poolaccount::Pooluser <| |> -> Slurm_top_account <| |>
      Slurm_top_account <| |> -> Slurm_sub_account <| |>
      Slurm_sub_account <| |> -> Slurm_user <| |>

    }

  }

}
