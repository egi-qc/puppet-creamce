class creamce inherits creamce::params {
  
  case $::operatingsystem {
    RedHat,SLC,SL:   {
      require fetchcrl,bdii,mysql
      include creamce::certificate
      include creamce::gridftp
      include creamce::nfs
      include creamce::tomcat 
      include creamce::install
      include creamce::config
      include creamce::acl
      include creamce::locallogger
      include creamce::gip
      include creamce::apel
      
      Class['install'] -> Class['tomcat'] -> Class['config'] -> Class['gip']
    }
    
    default: {
      # There is some fedora configuration present but I can't actually get it to work.
    }
  }
}

  
  
