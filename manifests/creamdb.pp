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
  
  $enc_std_password = mysql_password("${cream_db_password}")
  $enc_min_password = mysql_password("${cream_db_minpriv_password}")
  
  class { 'mysql::server':
    root_password => $mysql_password,
    override_options => $override_options
  }
  
  class {'creamce::database::configure_files':}
  
  mysql_user { "${cream_db_user}@${access_pattern}":
    ensure        => $ensure,
    password_hash => $enc_std_password
  }
  
  mysql_user { "${cream_db_user}@localhost":
    ensure        => $ensure,
    password_hash => $enc_std_password
  }
  
  mysql_user { "${cream_db_minpriv_user}@${access_pattern}":
    ensure        => $ensure,
    password_hash => $enc_min_password
  }

  mysql_user { "${cream_db_minpriv_user}@localhost":
    ensure        => $ensure,
    password_hash => $enc_min_password
  }
  
  mysql_database { "${cream_db_name}":
    ensure => 'present',
    charset => 'utf8'
  }
  
  mysql_database { "${delegation_db_name}":
    ensure => 'present',
    charset => 'utf8'
  }
  
  exec { "creamdb-import":
    command     => "cat /etc/glite-ce-cream/populate_creamdb_mysql.puppet.sql | mysql ${cream_db_name}",
    logoutput   => true,
    environment => "HOME=${::root_home}",
    refreshonly => true,
    path        => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin',
    timeout     => 300,
  }

  exec { "delegationdb-import":
    command     => "cat /etc/glite-ce-cream/populate_creamdb_mysql.puppet.sql | mysql ${delegation_db_name}",
    logoutput   => true,
    environment => "HOME=${::root_home}",
    refreshonly => true,
    path        => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin',
    timeout     => 300,
  }
  
  mysql_grant { "${cream_db_user}@${access_pattern}/${cream_db_name}.*":
    privileges => 'ALL',
    user       => "${cream_db_user}@${access_pattern}",
    table      => "${cream_db_name}.*"
  }

  mysql_grant { "${cream_db_user}@localhost/${cream_db_name}.*":
    privileges => 'ALL',
    user       => "${cream_db_user}@localhost",
    table      => "${cream_db_name}.*"
  }

  mysql_grant { "${cream_db_user}@${access_pattern}/${delegation_db_name}.*":
    privileges => 'ALL',
    user       => "${cream_db_user}@${access_pattern}",
    table      => "${delegation_db_name}.*"
  }

  mysql_grant { "${cream_db_user}@localhost/${delegation_db_name}.*":
    privileges => 'ALL',
    user       => "${cream_db_user}@localhost",
    table      => "${delegation_db_name}.*"
  }
    
  mysql_grant { "${cream_db_minpriv_user}@${access_pattern}/${cream_db_name}.db_info":
    privileges => ['SELECT (submissionEnabled,startUpTime)'],
    options    => ['GRANT'],
    user       => "${cream_db_minpriv_user}@${access_pattern}",
    table      => "${cream_db_name}.db_info"
  }
    
  mysql_grant { "${cream_db_minpriv_user}@localhost/${cream_db_name}.db_info":
    privileges => ['SELECT (submissionEnabled,startUpTime)'],
    options    => ['GRANT'],
    user       => "${cream_db_minpriv_user}@localhost",
    table      => "${cream_db_name}.db_info"
  }
    
  Class['mysql::server'] -> 
  Class['creamce::database::configure_files'] ->
  Mysql_user[ 
    "${cream_db_user}@${access_pattern}", 
    "${cream_db_user}@localhost",
    "${cream_db_minpriv_user}@${access_pattern}",
    "${cream_db_minpriv_user}@localhost"
  ] ->
  Mysql_database[ "${cream_db_name}", "${delegation_db_name}" ] ->
  Mysql_grant[ 
    "${cream_db_user}@${access_pattern}/${cream_db_name}.*",
    "${cream_db_user}@localhost/${cream_db_name}.*",
    "${cream_db_user}@${access_pattern}/${delegation_db_name}.*",
    "${cream_db_user}@localhost/${delegation_db_name}.*" ] ->
  Exec[ "creamdb-import", "delegationdb-import" ] ->
  Mysql_grant[
    "${cream_db_minpriv_user}@${access_pattern}/${cream_db_name}.db_info",
    "${cream_db_minpriv_user}@localhost/${cream_db_name}.db_info"
  ]
  
}
