class creamce::creamdb inherits creamce::params {

  class {'creamce::database::server':
    mysql_password    => $mysql_password,
    max_connections   => $max_connections,
  }
  class {'creamce::database::configure_files':
    require => Class['creamce::database::server'],
  }
  class {'creamce::database::configure_users':
    require => Class['creamce::database::server'],
  }
  class {'creamce::database::create':
    require => Class['creamce::database::server'],
  }
  class {'creamce::database::configure_tables':
    require => Class['creamce::database::server','creamce::database::create'],  
  }
  class {'creamce::database::configure_privileges':
    require => Class['creamce::database::server'],
  }
  class {'creamce::database::configure_otherpriv':
    require => Class['creamce::database::server','creamce::database::configure_tables'],
  }
#   Class['creamce::database::configure_files'] -> Class['creamce::database::create'] -> Class['creamce::database::configure_users'] -> Class['creamce::database::configure_privileges'] -> Class['creamce::database::configure_tables'] -> Class['creamce::database::configure_otherpriv'] ~> Service['mysqld']
  
}
