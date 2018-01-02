class creamce::gridengine inherits creamce::params {

  include creamce::blah
  include creamce::gip
  
  # ##################################################################################################
  # BLAHP setup (GE)
  # ##################################################################################################
  
  file{ "${blah_config_file}":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => '0644',
    content => template("creamce/blah.config.gridengine.erb"),
  }


  # ##################################################################################################
  # GE infoproviders
  # ##################################################################################################

  package { "glite-info-dynamic-ge":
    ensure  => present,
    tag     => [ "bdiipackages", "umdpackages" ],
  }
  
  file { "/etc/lrms/vqueues.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => '0644',
    content => template("creamce/gip/ge-vqueues.conf.erb"),
    require => Package["glite-info-dynamic-ge"],
    notify  => Service["bdii"],
  }
  
  file { "/etc/lrms/cluster.state":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => '0644',
    content => "Production",
    require => Package["glite-info-dynamic-ge"],
    notify  => Service["bdii"],
  }
  
  file { "/etc/lrms/sge.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => '0644',
    content => template("creamce/gip/ge-reporter.conf.erb"),
    require => Package["glite-info-dynamic-ge"],
    notify  => Service["bdii"],
  }
  
  file { "$gippath/plugin/glite-info-dynamic-ce":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => '0755',
    content => template("creamce/gip/glite-info-dynamic-ce-ge.erb"),
    require => Package["glite-info-dynamic-ge", "bdii"],
    notify  => Service["bdii"],
  }
  
  file { "/etc/lrms/scheduler.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => '0755',
    content => template("creamce/gip/scheduler.conf.ge.erb"),
    require => Package["glite-info-dynamic-ge"],   
    notify  => Service["bdii"],
  }

  


}
