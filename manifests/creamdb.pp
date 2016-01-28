class creamce::creamdb inherits creamce::params {

  # See https://forge.puppetlabs.com/puppetlabs/mysql
  $override_options = {
    'mysqld' => {
      'bind-address' => 'localhost',
      'max_connections' => $max_connections,
    }
  }
  
  if $access_by_domain == "true" {
    $access_pattern = "%.${cream_db_domain}"
  } else {
    $access_pattern = "${cream_db_host}"
  }
  
  class { 'mysql::server':
    root_password      => $mysql_password,
    override_options   => $override_options
  }
  
  class { 'creamce::database::configure_files':
    require  => Class['mysql::server']
  }
  
  class { 'creamce::database::create':
    require  => Class['mysql::server']
  }
  
  class { 'creamce::database::configure_users':
    host_pattern  => $access_pattern,
    require       => Class['mysql::server']
  }
  
  class { 'creamce::database::configure_tables':
    cream_sql_script      => "/etc/glite-ce-cream/populate_creamdb_mysql.puppet.sql",
    delegation_sql_script => "/etc/glite-ce-cream/populate_delegationcreamdb.puppet.sql",
    subscribe             => Class['creamce::database::configure_files', 'creamce::database::create']
  }
  
  class { 'creamce::database::configure_privileges':
    host_pattern  => $access_pattern,
    require       => Class['creamce::database::create', 'creamce::database::configure_users']
  }
  
  class { 'creamce::database::configure_otherpriv':
    host_pattern  => $access_pattern,
    require       => Class['creamce::database::configure_tables', 'creamce::database::configure_users']
  }
    
}
