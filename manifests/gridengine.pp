class creamce::gridengine inherits creamce::params {

  include creamce::blah
  include creamce::gip
  
  # ##################################################################################################
  # configure blah for Condor
  # ##################################################################################################
  
  file{ "${blah_config_file}":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => '0644',
    content => template("creamce/blah.config.gridengine.erb"),
  }


}
