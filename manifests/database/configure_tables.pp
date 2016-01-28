class creamce::database::configure_tables (
  $cream_sql_script      = "/etc/glite-ce-cream/populate_creamdb_mysql.puppet.sql",
  $delegation_sql_script = "/etc/glite-ce-cream/populate_delegationcreamdb.puppet.sql"
) inherits creamce::params {

  exec { "creamdb-import":
    command     => "mysql -h localhost -u root --password=\"${mysql_password}\" ${cream_db_name} < ${cream_sql_script}",
    logoutput   => true,
    refreshonly => true,
    path        => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin',
    timeout     => 300,
  }

  exec { "delegationdb-import":
    command     => "mysql -h localhost -u root --password=\"${mysql_password}\" ${delegation_db_name} < ${delegation_sql_script}",
    logoutput   => true,
    refreshonly => true,
    path        => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin',
    timeout     => 300,
  }
  
}
