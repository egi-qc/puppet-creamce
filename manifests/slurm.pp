class creamce::slurm inherits creamce::params {

  include creamce::blah
  require creamce::gip
  
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
  
  if $slurm_config_ssh {

    exec { "cleanup_sshd_config":
      command => "/bin/sed -i -e '/^\s*HostbasedAuthentication/d' /etc/ssh/sshd_config",
    }

    exec { "fillin_sshd_config":
      command   => "/bin/echo \"HostbasedAuthentication = yes\" >> /etc/ssh/sshd_config",
      subscribe => Exec["cleanup_sshd_config"],
    }

    $se_host_list = join(keys($se_list), " ")
    $lrms_host_list = "${torque_server} ${ce_host} ${se_host_list}"
    $extra_host_list = join($shosts_equiv_extras, " ")
    # TODO define script
    $lrms_host_script = "/bin/echo"
    
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
      require => File["/usr/sbin/puppet-lrms-shostsconfig"],
    }

  }

}
