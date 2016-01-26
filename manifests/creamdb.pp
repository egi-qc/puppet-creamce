class creamce::creamdb inherits creamce::params {

  # See https://forge.puppetlabs.com/puppetlabs/mysql
  $override_options = {
    'mysqld' => {
      'bind-address' => 'localhost',
      'max_connections' => $max_connections,
    }
  }
  
  $enc_cream_passwd = mysql_password("${cream_db_password}")
  $enc_minpriv_passwd = mysql_password("${cream_db_minpriv_password}")
  
  class { 'mysql::server':
    root_password => $mysql_password,
    override_options => $override_options
  }
  
  class {'creamce::database::configure_files':}
  
  mysql::db { "${cream_db_user}@${cream_db_host}/${cream_db_name}":
    ensure => 'present',
    user => "${cream_db_user}",
    password => $enc_cream_passwd,
    dbname => "${cream_db_name}",
    charset => 'utf8',
    host => "${cream_db_host}",
    grant => ['ALL'],
    
  }
  
  mysql::db { "${cream_db_user}@${cream_db_host}/${delegation_db_name}":
    ensure => 'present',
    user => "${cream_db_user}",
    password => $enc_cream_passwd,
    dbname => "${delegation_db_name}",
    charset => 'utf8',
    host => "${cream_db_host}",
    grant => ['ALL'],
    
  }

  mysql::db { "${cream_db_user}@${cream_db_host}/${information_db_name}":
    ensure => 'present',
    user => "${cream_db_user}",
    password => $enc_cream_passwd,
    dbname => "${information_db_name}",
    charset => 'utf8',
    host => "${cream_db_host}",
    grant => ['ALL'],
    
  }

  #class {'creamce::database::configure_tables':}
  
  
}
