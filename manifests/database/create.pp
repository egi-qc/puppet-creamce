class creamce::database::create inherits creamce::params {

  mysql_database { "${cream_db_name}":
    ensure => 'present',
    charset => 'utf8'
  }
  
  mysql_database { "${delegation_db_name}":
    ensure => 'present',
    charset => 'utf8'
  }
  
}
