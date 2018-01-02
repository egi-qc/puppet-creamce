class creamce::lcmaps inherits creamce::params {

  package { [
              "lcmaps-plugins-basic",
              "lcmaps-plugins-voms",
              "lcmaps-plugins-verify-proxy",
              "lcas-plugins-basic",
              "lcas-plugins-voms",
              "lcas-plugins-check-executable"
            ]:
    ensure => present,
    tag    => [ "lcmapspackages", "umdpackages" ],
  }
  
  file { "/etc/lcas/lcas-glexec.db":
    ensure  => file,
    owner   => "root",
    group   => "root",
    mode    => '0644',
    content => template("creamce/lcas-glexec.db.erb"),
    require => Package[ "lcas-plugins-basic", "lcas-plugins-voms", "lcas-plugins-check-executable" ],
  }
  
  file { "/etc/lcmaps/lcmaps-glexec.db":
    ensure  => file,
    owner   => "root",
    group   => "root",
    mode    => '0640',
    content => template("creamce/lcmaps-glexec.db.erb"),
    require => Package[ "lcmaps-plugins-basic", "lcmaps-plugins-voms", "lcmaps-plugins-verify-proxy" ],
  }

  file { "/etc/lcas/lcas.db":
    ensure  => file,
    owner   => "root",
    group   => "root",
    mode    => '0644',
    content => template("creamce/lcas.db.erb"),
    require => Package[ "lcas-plugins-basic", "lcas-plugins-voms", "lcas-plugins-check-executable" ],
  }
  
  file { "/etc/lcmaps/lcmaps.db":
    ensure  => file,
    owner   => "root",
    group   => "root",
    mode    => '0640',
    content => template("creamce/lcmaps.db.erb"),
    require => Package[ "lcmaps-plugins-basic", "lcmaps-plugins-voms", "lcmaps-plugins-verify-proxy" ],
  }

  if $cream_ban_list {

    file { "${cream_ban_list_file}":
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => '0644',
      content => template("creamce/ban_users.db.erb"),
    }

  } else {

    exec { "touch_banlist":
      command => "/bin/touch ${cream_ban_list_file}",
    }

  }

}
