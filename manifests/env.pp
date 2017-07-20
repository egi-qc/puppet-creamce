class creamce::env inherits creamce::params {

  file {"/etc/profile.d/grid-env.sh":
    ensure  => present,
    content => template("creamce/gridenvsh.erb"),
    owner   => "root",
    group   => "root",
    mode    => '0755',
  }  
  
  file {"/etc/profile.d/grid-env.csh":
    ensure  => present,
    content => template("creamce/gridenvcsh.erb"),
    owner   => "root",
    group   => "root",
    mode    => '0644',
  }

}
