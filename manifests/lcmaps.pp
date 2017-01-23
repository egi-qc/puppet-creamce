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
  
  define lcas_db_file($lcas_filename, $config_glexec) {

    file { "${lcas_filename}":
      ensure => file,
      owner => "root",
      group => "root",
      mode => 0644,
      content => template("creamce/lcas-glexec.db.erb"),
      require => Package[ "lcas-plugins-basic", "lcas-plugins-voms", "lcas-plugins-check-executable" ],
    }

  }
  
  $lcas_file_defs = {
    'lcas_conf_for_cream' => {
      'lcas_filename' => "/etc/lcas/lcas-glexec.db",
      'config_glexec' => true,
    },
    'lcas_conf_for_gftp' => {
      'lcas_filename' => "/etc/lcas/lcas.db",
      'config_glexec' => false,
    }
  }
  create_resources(lcas_db_file, $lcas_file_defs)

  define lcmaps_db_file($lcmaps_filename, $config_glexec) {

    file { "${lcmaps_filename}":
      ensure => file,
      owner => "root",
      group => "root",
      mode => 0640,
      content => template("creamce/lcmaps-glexec.db.erb"),
      require => Package[ "lcmaps-plugins-basic", "lcmaps-plugins-voms", "lcmaps-plugins-verify-proxy" ],
    }

  }

  $lcmaps_file_defs = {
    'lcmaps_conf_for_cream' => {
      'lcmaps_filename' => "/etc/lcmaps/lcmaps-glexec.db",
      'config_glexec'   => true,
    },
    'lcmaps_conf_for_gftp' => {
      'lcmaps_filename' => "/etc/lcmaps/lcmaps.db",
      'config_glexec'   => false,
    }
  }
  create_resources(lcmaps_db_file,$lcmaps_file_defs)

  if $cream_ban_list {

    file { "${cream_ban_list_file}":
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => 0644,
      content => template("creamce/ban_users.db.erb"),
    }

  } else {

    exec { "touch_banlist":
      command => "/bin/touch ${cream_ban_list_file}",
    }

  }

}
