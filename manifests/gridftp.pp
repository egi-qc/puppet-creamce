class creamce::gridftp inherits creamce::params {

  require creamce::yumrepos
  
  if $use_argus == "true" {
    $gridftp_auth_plugin = "argus-gsi-pep-callout"
  } else {
    $gridftp_auth_plugin = "lcas-lcmaps-gt4-interface"
  }
  
  class{"gridftp::install":}
  
  class{"gridftp::service":}
  
  class{"gridftp::config":
    connections_max       => "${gridftp_connections_max}",
    port                  => "${gridftp_port}",
    globus_tcp_port_range => "${globus_tcp_port_range}"
  }
  
  package { "globus-proxy-utils":
    ensure => present
  }
  
  package { "kill-stale-ftp":
    ensure => present
  }
  
  package { "${gridftp_auth_plugin}":
    ensure => present
  }

  Class[Gridftp::Install] -> Package["globus-proxy-utils", "kill-stale-ftp", "${gridftp_auth_plugin}"] -> Class["Gridftp::Config"] -> Class[Gridftp::Service]


}
