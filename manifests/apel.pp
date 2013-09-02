class creamce::apel inherits creamce::params {
  
  case $batch_system {
    lsf: {
      package {["batchacct-common","batchacct-cecol","oracle-instantclient-tnsnames.ora"]: ensure => present }
      file {"/etc/batchacct/connection":
        ensure => present,
        owner => "root",
        group => "root",
        mode => 0400,
        content => template("creamce/apelconf.erb"),
      }
      service {"batchacct-cecold":
	ensure => running
      }
      Package["batchacct-common","batchacct-cecol","oracle-instantclient-tnsnames.ora"] -> File['/etc/batchacct/connection'] ~> Service['batchacct-cecold']
    }
    default: {
      fail "No BATCH system default defined"
    }
  }
}
