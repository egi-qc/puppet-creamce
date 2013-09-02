class creamce::gridftp inherits creamce::params {
  
  class{"gridftp::install":}
  class{"gridftp::service":}
  class{"gridftp::config":
    connections_max => "150",
    port => "2811",
    globus_tcp_port_range => $globus_tcp_port_range
  }
#  file {"/etc/sysconfig/globus-gridftp-server":
#    ensure 	=> file,
#    content	=> template("creamce/gridftp_sysconf.erb"),
#    require	=> Package["globus-gridftp-server-progs"],
#    notify	=> Service["globus-gridftp-server"]
#  }
#  file {"/etc/gridftp.conf":
#    ensure 	=> file,
#    content	=> template("creamce/gridftp.conf.erb"),
#    require	=> Package["globus-gridftp-server-progs"],
#    notify	=> Service["globus-gridftp-server"]
#  }
  Class[Gridftp::Install] -> Class["Gridftp::Config"] -> Class[Gridftp::Service]

}
