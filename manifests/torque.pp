class creamce::torque inherits creamce::params {

  #
  # configure blah for LSF
  #
  file{"/etc/blah.config":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0644,
    content => template("creamce/blah.config.torque.erb"),
  }

}
