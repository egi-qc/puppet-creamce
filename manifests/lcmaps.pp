class creamce::lcmaps inherits creamce::params {

  require creamce::yumrepos

  package { "lcmaps-plugins-basic":
    ensure => present
  }

  package { "lcmaps-plugins-voms":
    ensure => present
  }

  package { "lcmaps-plugins-verify-proxy":
    ensure => present
  }

  package { "lcas-plugins-basic":
    ensure => present
  }

  package { "lcas-plugins-voms":
    ensure => present
  }

  package { "lcas-plugins-check-executable":
    ensure => present
  }

  package { "lcg-expiregridmapdir":
    ensure => present
  }

}
