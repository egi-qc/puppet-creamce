class creamce::condor inherits creamce::params {

  include creamce::blah
  require creamce::gip
  
  #
  # configure blah for Condor
  #
  
  file{"/etc/blah.config":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    content => template("creamce/blah.config.condor.erb"),
  }

  #
  # configure infoprovider for Condor
  #
  
  #package{"****-condor-****":
  #  ensure  => present,
  #  require => Package["dynsched-generic"],
  #  notify  => Class[Bdii::Service],
  #}

  # Usually installed by rpm scriptlets
  #file {"$gippath/plugin/glite-info-dynamic-scheduler-wrapper":
  #  ensure => present,
  #  owner   => "${info_user}",
  #  group   => "${info_group}",
  #  mode => 0755,
  #  content => template("creamce/gip/glite-info-dynamic-scheduler-wrapper.erb"),
  #  require => Package["dynsched-generic"],
  #  notify  => Class[Bdii::Service],
  #}
}
