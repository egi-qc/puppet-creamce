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
  
  if $cream_config_ssh {
    
      class { 'creamce::sshconfig':
        lrms_host_script => "/usr/bin/scontrol -o show nodes | grep -Eo 'NodeHostName=([^\s]+)' | cut -d \"=\" -f 2",
        lrms_master_node => $slurm_master
      }

  }

}
