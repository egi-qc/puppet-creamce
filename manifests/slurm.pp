class creamce::slurm inherits creamce::params {

  include creamce::blah
  require creamce::gip
  
  $vo_group_table = build_vo_group_table($voenv)
  
  # ##################################################################################################
  # BLAHP setup
  # ##################################################################################################

  file{"${blah_config_file}":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    content => template("creamce/blah.config.slurm.erb"),
  }

  # ##################################################################################################
  # SLURM infoproviders
  # ##################################################################################################

  package{"info-dynamic-scheduler-slurm":
    ensure  => present,
    require => Package["dynsched-generic"],
    notify  => Class[Bdii::Service],
  }

  file { "/etc/lrms/scheduler.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    content => template("creamce/gip/slurm-provider.conf.erb"),
    require => Package["info-dynamic-scheduler-slurm"],
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

  define slurm_user ($pool_user, $accounts, $partitions, $dep_resources = undef) {

    $partstr = join($partitions, ",")
    $acctstr = join($accounts, ",")

    exec { "${title}":
      command => "/usr/bin/sacctmgr -i create user name=${pool_user} account=${acctstr} partition=${partstr}",
      unless  => "/usr/bin/sacctmgr -p -n show user ${pool_user} | grep ${pool_user}",
    }
    
    if $dep_resources {
      $dep_resources -> Exec["${title}"]
    }
    
  }

  define slurm_top_account ($acct, $dep_resources = undef, $sub_resources = undef) {
    
    exec { "${title}":
      command => "/usr/bin/sacctmgr -i create account name=${acct} description=\"VO ${acct}\" organization=grid",
      unless  => "/usr/bin/sacctmgr -p -n show account ${acct} | grep ${acct}",
    }
    
    if $dep_resources {
      $dep_resources -> Exec["${title}"]
    }
    
    if $sub_resources {
      Exec["${title}"] -> $sub_resources
    }

  }
  
  define slurm_sub_account ($acct, $p_acct, $dep_resources = undef, $sub_resources = undef) {

    exec { "${title}":
      command => "/usr/bin/sacctmgr -i create account name=${acct} parent=${p_acct} description=\"VO Group ${acct}\" organization=grid",
      unless  => "/usr/bin/sacctmgr -p -n show account ${acct} | grep ${acct}",
    }
    
    if $dep_resources {
      $dep_resources -> Exec["${title}"]
    }
    
    if $sub_resources {
      Exec["${title}"] -> $sub_resources
    }

  }
  
  if $slurm_config_acct {

    if $slurm_use_std_acct {

      # Barriers for account and user creation
      notify { "top_accounts_created":
        message => "Created VO top accounts",
      }

      notify { "sub_accounts_created":
        message => "Created VO group accounts",
        require => Notify["top_accounts_created"],
      }

      $top_slurm_accts = build_slurm_accts($voenv, "top", undef, Notify["top_accounts_created"])
      create_resources(slurm_top_account, $top_slurm_accts)

      $sub_slurm_accts = build_slurm_accts($voenv, "sub", 
                                           Notify["top_accounts_created"], Notify["sub_accounts_created"])
      create_resources(slurm_sub_account, $sub_slurm_accts)
      
      $slurm_acct_users = build_slurm_users($voenv, $grid_queues, $default_pool_size,
                                            $slurm_use_std_acct, Notify["sub_accounts_created"])
      create_resources(slurm_user, $slurm_acct_users)

    } else {
    
      $slurm_acct_users = build_slurm_users($voenv, $grid_queues,
                                            $default_pool_size, $slurm_use_std_acct, undef)
      create_resources(slurm_user, $slurm_acct_users)

    }
  }

}
