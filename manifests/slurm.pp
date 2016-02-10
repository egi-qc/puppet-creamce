class creamce::slurm inherits creamce::params {

  #
  # configure blah for SLURM
  #
  file{"/etc/blah.config":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0644,
    content => template("creamce/blah.config.slurm.erb"),
  }

  #
  # configure infoprovider for SLURM
  #
  package{"info-dynamic-scheduler-slurm":
    ensure => present
  }

}
