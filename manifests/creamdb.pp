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
    root_password => $mysql_password,
    override_options => $override_options
  }
  
  class {'creamce::database::configure_files':}
  
  mysql::db { "${cream_db_user}@${access_pattern}/${cream_db_name}":
    ensure => 'present',
    user => "${cream_db_user}",
    password => "${cream_db_password}",
    dbname => "${cream_db_name}",
    charset => 'utf8',
    host => "${access_pattern}",
    grant => ['ALL'],
    sql => "/etc/glite-ce-cream/populate_creamdb_mysql.puppet.sql"
  }
  
  mysql::db { "${cream_db_user}@localhost/${cream_db_name}":
    ensure => 'present',
    user => "${cream_db_user}",
    password => "${cream_db_password}",
    dbname => "${cream_db_name}",
    charset => 'utf8',
    host => "localhost",
    grant => ['ALL'],
  }

  mysql::db { "${cream_db_user}@${access_pattern}/${delegation_db_name}":
    ensure => 'present',
    user => "${cream_db_user}",
    password => "${cream_db_password}",
    dbname => "${delegation_db_name}",
    charset => 'utf8',
    host => "${access_pattern}",
    grant => ['ALL'],
    sql => "/etc/glite-ce-cream/populate_delegationcreamdb.puppet.sql"
  }

  mysql::db { "${cream_db_user}@localhost/${delegation_db_name}":
    ensure => 'present',
    user => "${cream_db_user}",
    password => "${cream_db_password}",
    dbname => "${delegation_db_name}",
    charset => 'utf8',
    host => "localhost",
    grant => ['ALL'],
  }

  Class ['mysql::server'] -> Class ['creamce::database::configure_files'] -> Mysql::Db["${cream_db_user}@${access_pattern}/${cream_db_name}", "${cream_db_user}@localhost/${cream_db_name}", "${cream_db_user}@${access_pattern}/${delegation_db_name}", "${cream_db_user}@localhost/${delegation_db_name}"]
  
}
