class creamce::database::create inherits creamce::params {
  #
  # database
  #

  database{"${cream_db_name}":
    ensure  => present,
  }
  
  database{"${information_db_name}":
    ensure  => present,
  }
  
  database{"${delegation_db_name}":
    ensure  => present,
  }

  exec {'drop_test_db':
    command => "/usr/bin/mysql -u root mysql -p'${mysql_password}' -e \"drop database test;\"",
    onlyif  => "/usr/bin/mysql -u root mysql -p'${mysql_password}' -e \"connect test;\" 2>/dev/null",
    loglevel => notice,
  }

}
