class creamce::database::configure_otherpriv (
  $host_pattern = "${cream_db_host}",
) inherits creamce::params {

  mysql_grant { "${cream_db_minpriv_user}@${host_pattern}/${cream_db_name}.db_info":
    privileges => ['SELECT (submissionEnabled,startUpTime)'],
    options    => ['GRANT'],
    user       => "${cream_db_minpriv_user}@${host_pattern}",
    table      => "${cream_db_name}.db_info",
  }
    
  mysql_grant { "${cream_db_minpriv_user}@localhost/${cream_db_name}.db_info":
    privileges => ['SELECT (submissionEnabled,startUpTime)'],
    options    => ['GRANT'],
    user       => "${cream_db_minpriv_user}@localhost",
    table      => "${cream_db_name}.db_info",
  }

}
