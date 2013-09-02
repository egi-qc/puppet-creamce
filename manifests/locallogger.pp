class creamce::locallogger inherits creamce::params {

  service {"glite-lb-logd":
    ensure => running,
    hasstatus  => true,
    hasrestart => true,
    require => Class["creamce::certificate"]
  }
  service {"glite-lb-locallogger":
    ensure => running,
    hasstatus  => true,
    hasrestart => true,
    require => Class["creamce::certificate"]
  }
  service {"glite-lb-interlogd":
    ensure => running,
    hasstatus  => true,
    hasrestart => true,
    require => Class["creamce::certificate"]
  }
  

}
