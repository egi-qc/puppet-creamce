class creamce::database::configure_files inherits creamce::params {
  #
  # files
  #
  file {["/etc/glite-ce-dbtool","/etc/glite-ce-cream"]:
    ensure => directory
  }

  
  file { "/etc/glite-ce-dbtool/creamdb_min_access.conf":
    ensure => present,
    content => template("creamce/creamdb_min_access.conf.erb"),
    owner => "root",
    group => "ldap",
    mode => 0640,
  }
  
  #
  # update mysql templates
  #
  file {"/etc/glite-ce-cream/populate_creamdb_mysql.tmp.sql":
    ensure => present,
    content => template("creamce/populate_creamdb_mysql.sql.erb"),
    owner => "root",
    group => "root",
    mode => 0600,
  }
  
  file {"/etc/glite-ce-cream/populate_delegationcreamdb.tmp.sql":
    ensure => present,
    content => template("creamce/populate_delegationcreamdb.sql.erb"),
    owner => "root",
    group => "root",
    mode => 0600,
  }
}
