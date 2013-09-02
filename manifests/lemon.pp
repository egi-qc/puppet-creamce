class creamce::lemon inherits creamce::params {

  # bdii 
  include bdii::lemon

  # gridftp
  include gridftp::lemon

  # tomcat
  lemon::metric{'40':}
  lemon::metric{'30055':
    params => {
      actuator => "/sbin/service $tomcat restart"
    }
  }
  
  case $::lsbmajdistrelease {
    6: {
      # fixme: should have an OS dependency here
      $cmdregex = "python /usr/lib/python2.6/site-packages/batchacct/whisk.py.*"
    }
    default: {
      $cmdregex = "python /usr/lib/python2.4/site-packages/batchacct/whisk.py.*" 
    }
  }
  
  # apel
  lemon::metric{'12012':
    params => {
      cmdregex => "${cmdregex}"
    }
  }
  lemon::metric{'12013':}
  lemon::metric{'33072':}
  lemon::metric{'33073':}
  

  # FIXME could add metrics and exceptions to monitor BLAH, BUpdate and BNotifier ? 

}
