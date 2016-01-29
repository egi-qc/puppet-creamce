class creamce::gridftp inherits creamce::params {
  
  class{"gridftp::install":}
  class{"gridftp::service":}
  class{"gridftp::config":
    connections_max       => "${gridftp_connections_max}",
    port                  => "${gridftp_port}",
    globus_tcp_port_range => "${globus_tcp_port_range}"
  }
  Class[Gridftp::Install] -> Class["Gridftp::Config"] -> Class[Gridftp::Service]

}
