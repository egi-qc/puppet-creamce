class creamce::database::create inherits creamce::params {

  mysql_database { "${cream_db_name}":
    ensure  => 'present',
    charset => 'latin1',
    collate => 'latin1_general_ci'
  }
  
  mysql_database { "${delegation_db_name}":
    ensure  => 'present',
    charset => 'latin1',
    collate => 'latin1_general_ci'
  }
  
}
