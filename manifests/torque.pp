class creamce::torque inherits creamce::params {

  include creamce::blah
  require creamce::gip
  
  $vo_group_table = build_vo_group_table($voenv)
  
  if $torque_use_maui {
    $required_pkgs = [ "torque-client", "maui-client" ]
  } else {
    $required_pkgs = [ "torque-client" ]
  }

  package { $required_pkgs:
    ensure  => present,
  }
  
  # ##################################################################################################
  # BLAHP setup (TORQUE)
  # ##################################################################################################

  file { "${blah_config_file}":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    content => template("creamce/blah.config.torque.erb"),
  }
  
  if $use_blparser {

    file { "/etc/blparser.conf":
      ensure  => present,
      owner   => "root",
      group   => "root",
      mode    => 0644,
      content => template("creamce/blparser.conf.torque.erb"),
    }

    $file_to_rotate = "/var/log/cream/glite-pbsparser.log"
    
    file { "/etc/logrotate.d/glite-pbsparser":
      ensure  => present,
      owner   => "root",
      group   => "root",
      mode    => 0644,
      content => template("creamce/blahp-logrotate.erb"),
    }
    
    service { "glite-ce-blah-parser":
      ensure    => running,
      subscribe => File["/etc/blparser.conf"],
    }

  }
  
  if $istorqueinstalled == "true" {

    service { "glite-ce-blah-parser":
      ensure    => running,
      subscribe => File["${blah_config_file}"],
    }

  }
  
  #
  # TODO check https://wiki.italiangrid.it/twiki/bin/view/CREAM/SystemAdministratorGuideForEMI3#1_2_5_Choose_the_BLAH_BLparser_d
  #

  # ##################################################################################################
  # TORQUE infoproviders
  # ##################################################################################################

  package { "lcg-info-dynamic-scheduler-pbs":
    ensure  => present,
    require => Package[$required_pkgs],
    notify  => Class[Bdii::Service],
  }
  
  file { "/etc/lrms/scheduler.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    content => template("creamce/gip/torque-provider.conf.erb"),
    require => Package["lcg-info-dynamic-scheduler-pbs"],
  }
  
  if $torque_use_maui {
  
    file { "/var/spool/maui/maui.cfg":
      ensure  => present,
      owner   => "root",
      group   => "root",
      mode    => 0644,
      content => template("creamce/maui.cfg.erb"),
      require => Package["maui-client"],
    }
    
  }
  
  # ##################################################################################################
  # TORQUE client
  # ##################################################################################################
  
  if $torque_config_client and $istorqueinstalled == "false" {
  
    package { "munge":
      ensure  => present,
    }

    file { "/etc/torque/server_name":
      ensure  => present,
      owner   => "root",
      group   => "root",
      mode    => 0644,
      content => "${torque_server}",
      require => Package["torque-client"],
    }
  
    if $munge_key_path == "" {

      fail("Munge key not defined")

    } else {

      service { [ "munge", "trqauthd" ]:
        ensure   => running,
        require  => [ File["/etc/torque/server_name"], Package["munge"] ],
      }
  
      file { "/etc/munge/munge.key":
        ensure  => present,
        owner   => "munge",
        group   => "munge",
        mode    => 0400,
        source  => "${munge_key_path}",
        require => Package["munge"],
        notify  => Service["munge"],
      }

    }

    if $torque_config_ssh {

      exec { "cleanup_sshd_config":
        command => "/bin/sed -i -e '/^\s*HostbasedAuthentication/d' -e '/^\s*IgnoreUserKnownHosts/d' -e '/^\s*IgnoreRhosts/d' /etc/ssh/sshd_config",
      }

      exec { "fillin_sshd_config":
        command => "/bin/echo \"
HostbasedAuthentication = yes
IgnoreUserKnownHosts yes
IgnoreRhosts yes\" >> /etc/ssh/sshd_config",
        require => Exec["cleanup_sshd_config"],
        notify  => Service["sshd"],
      }


      $se_host_list = join(keys($se_list), " ")
      $lrms_host_list = "${torque_server} ${ce_host} ${se_host_list}"
      $extra_host_list = join($shosts_equiv_extras, " ")
      $lrms_host_script = "/usr/bin/pbsnodes -a -s ${torque_server}"
    
      file { "/usr/sbin/puppet-lrms-shostsconfig":
        ensure  => present,
        owner   => "root",
        group   => "root",
        mode    => 0744,
        content => template("creamce/puppet-lrms-shostsconfig.erb"),
      }
    
      file { "/etc/cron.d/puppet-lrms-shostsconfig":
        ensure  => present,
        owner   => "root",
        group   => "root",
        mode    => 0644,
        content => "${torque_ssh_cron_sched} root /usr/sbin/puppet-lrms-shostsconfig",
        require => File["/usr/sbin/puppet-lrms-shostsconfig"],
      }

      exec { "/usr/sbin/puppet-lrms-shostsconfig":
        require => [ File["/usr/sbin/puppet-lrms-shostsconfig"], Service[ "munge", "trqauthd" ] ],
        notify  => Service["sshd"],
      }
      
      service { "sshd":
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        alias      => "sshd",
      }

    }
    
  }

  define queue_member ($queue, $group, $dep_resources = undef) {
      
    exec { "${title}":
      command => "/usr/bin/qmgr -c \"set queue ${queue} acl_groups += ${group}\"",
      unless  => "/usr/bin/qmgr -c \"list queue ${queue} acl_groups\" | awk '/acl_groups/,EOF {print $NF}'| grep -qwi ${group}",
    }
      
    if $dep_resources {
      $dep_resources -> Exec["${title}"]
    }
  }

  if $torque_config_pool {    

    if $torque_config_client and $istorqueinstalled == "false" {
      $queue_group_table = build_queue_group_tuples($grid_queues, Service["munge", "trqauthd"])
    }else{
      $queue_group_table = build_queue_group_tuples($grid_queues, undef)
    }
    create_resources(queue_member, $queue_group_table)
    
  }

}
