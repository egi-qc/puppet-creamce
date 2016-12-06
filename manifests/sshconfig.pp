class creamce::sshconfig (
  $lrms_host_script,        # used in puppet-lrms-shostsconfig
  $lrms_master_node = ''
) inherits creamce::params {

  exec { "cleanup_sshd_config":
    command => "/bin/sed -i -e '/^\s*HostbasedAuthentication/d' -e '/^\s*IgnoreUserKnownHosts/d' -e '/^\s*IgnoreRhosts/d' /etc/ssh/sshd_config",
  }

  exec { "fillin_sshd_config":
    command => "/bin/echo \"
HostbasedAuthentication = yes
IgnoreUserKnownHosts yes
IgnoreRhosts yes\" >> /etc/ssh/sshd_config",
    require => Exec["cleanup_sshd_config"],
    notify  => Exec["shostsconfig_single_run"],
  }

  $se_host_list = join(keys($se_list), " ")
  $extra_host_list = join($shosts_equiv_extras, " ")
  if $lrms_master_node == $ce_host {
    $lrms_host_list = "${ce_host} ${se_host_list}"
  } else {
    $lrms_host_list = "${lrms_master_node} ${ce_host} ${se_host_list}"
  }

  file { "/usr/sbin/puppet-lrms-shostsconfig":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0744,
    content => template("creamce/puppet-lrms-shostsconfig.erb"),
  }

  exec { "shostsconfig_single_run":
    command => "/usr/sbin/puppet-lrms-shostsconfig",
    require => File["/usr/sbin/puppet-lrms-shostsconfig"],
  }
  
  file { "/etc/cron.d/puppet-lrms-shostsconfig":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    content => "${ssh_cron_sched} root /usr/sbin/puppet-lrms-shostsconfig",
    require => File["/usr/sbin/puppet-lrms-shostsconfig"],
  }

}

