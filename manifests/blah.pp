class creamce::blah inherits creamce::params {

  # ##################################################################################################
  # BLAHP Package
  # ##################################################################################################

  package { "BLAH":
    ensure  => present,
    tag     => [ "creamcepackages" ],
  }

  # ##################################################################################################
  # BLAHP setup (common actions)
  # ##################################################################################################

  file { "/var/log/cream/accounting":
    ensure => directory,
    owner  => "root",
    group  => "tomcat",
    mode   => '0730',
    tag    => [ "blahconffiles" ],
  }

  file { "/var/blah":
    ensure => directory,
    owner  => "tomcat",
    group  => "tomcat",
    mode   => '0771',
    tag    => [ "blahconffiles" ],
  }

  $file_to_rotate = "/var/log/cream/accounting/blahp.log"
  
  file { "/etc/logrotate.d/blahp-logrotate":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => '0644',
    content => template("creamce/blahp-logrotate.erb"),
    tag    => [ "blahconffiles" ],
  }
  
  unless $use_blparser {
  
    file { "/etc/logrotate.d/bnotifier-logrotate":
      ensure  => present,
      content => template("creamce/bnotifier-logrotate.erb"),
      owner   => "root",
      group   => "root",
      mode    => '0644',
      tag    => [ "blahconffiles" ],
    }

    file { "/etc/logrotate.d/bupdater-logrotate":
      ensure  => present,
      content => template("creamce/bupdater-logrotate.erb"),
      owner   => "root",
      group   => "root",
      mode    => '0644',
      tag    => [ "blahconffiles" ],
    }
  
  }
  
  Package <| tag == 'creamcepackages' |> -> File <| tag == 'blahconffiles' |>

}
