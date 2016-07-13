class creamce inherits creamce::params {
  
  if $::operatingsystem == "CentOS" and $::operatingsystemmajrelease >= 7 {
  
    include creamce::config
    include creamce::tomcat
    include creamce::creamdb
    
    include creamce::gridftp
    
    #include creamce::glexec

    include creamce::gip

    include creamce::locallogger

  } else {
  
    # TODO
  
  }
  
}

  
  
