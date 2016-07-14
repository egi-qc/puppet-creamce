class creamce inherits creamce::params {
  
  if $::operatingsystem == "CentOS" and $::operatingsystemmajrelease >= 7 {
  
    include creamce::config

    include creamce::creamdb
    
    if $use_argus == "false" {
        include creamce::glexec
    }

    include creamce::gridftp
    
    include creamce::gip

    include creamce::locallogger

    #
    # TODO install systemd scripts from emi-cream-ce
    #

  } else {
  
    # TODO
  
  }
  
}

  
  
