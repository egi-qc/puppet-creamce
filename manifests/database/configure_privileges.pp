class creamce::database::configure_privileges (
  $host_pattern = "${cream_db_host}",
) inherits creamce::params {

  mysql_grant { "${cream_db_user}@${host_pattern}/${cream_db_name}.*":
    privileges => 'ALL',
    user       => "${cream_db_user}@${host_pattern}",
    table      => "${cream_db_name}.*"
  }

  mysql_grant { "${cream_db_user}@localhost/${cream_db_name}.*":
    privileges => 'ALL',
    user       => "${cream_db_user}@localhost",
    table      => "${cream_db_name}.*"
  }

  mysql_grant { "${cream_db_user}@${host_pattern}/${delegation_db_name}.*":
    privileges => 'ALL',
    user       => "${cream_db_user}@${host_pattern}",
    table      => "${delegation_db_name}.*"
  }

  mysql_grant { "${cream_db_user}@localhost/${delegation_db_name}.*":
    privileges => 'ALL',
    user       => "${cream_db_user}@localhost",
    table      => "${delegation_db_name}.*"
  }
  
}
