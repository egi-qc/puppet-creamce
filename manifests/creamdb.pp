class creamce::creamdb inherits creamce::params {

  require creamce::install

  # ##################################################################################################
  # mysqld setup
  # See https://forge.puppetlabs.com/puppetlabs/mysql
  # ##################################################################################################

  if $access_by_domain == "true" {
    $access_pattern = "%.${cream_db_domain}"
  } else {
    $access_pattern = "${cream_db_host}"
  }
  
  class { 'mysql::server':
    root_password      => $mysql_password,
    override_options   => $mysql_override_options
  }
  
  # ##################################################################################################
  # configuration files
  # ##################################################################################################
  
  #
  # TODO verify privileges and move into gip.pp in case
  #
  file { "/etc/glite-ce-dbtool/creamdb_min_access.conf":
    ensure   => present,
    content  => template("creamce/creamdb_min_access.conf.erb"),
    owner    => "root",
    group    => "root",
    mode     => 0644,
    loglevel => err,
  }

  #
  # TODO use scripts from package
  #
  file { "/etc/glite-ce-cream/populate_creamdb_mysql.puppet.sql":
    ensure   => present,
    content  => template("creamce/populate_creamdb_mysql.sql.erb"),
    owner    => "root",
    group    => "root",
    mode     => 0600,
    require  => Class['mysql::server'],
  }
  
  file { "/etc/glite-ce-cream/populate_delegationcreamdb.puppet.sql":
    ensure   => present,
    content  => template("creamce/populate_delegationcreamdb.sql.erb"),
    owner    => "root",
    group    => "root",
    mode     => 0600,
    require  => Class['mysql::server'],
  }


  # ##################################################################################################
  # create database
  # ##################################################################################################
  
  mysql_database { "${cream_db_name}":
    ensure   => 'present',
    charset  => 'latin1',
    collate  => 'latin1_general_ci',
    require  => Class['mysql::server'],
  }
  
  mysql_database { "${delegation_db_name}":
    ensure   => 'present',
    charset  => 'latin1',
    collate  => 'latin1_general_ci',
    require  => Class['mysql::server'],
  }
  
  # ##################################################################################################
  # tables
  # ##################################################################################################
  
  exec { "populate-creamdb":
    command     => "mysql -h localhost -u root --password=\"${mysql_password}\" ${cream_db_name} < /etc/glite-ce-cream/populate_creamdb_mysql.puppet.sql",
    refreshonly => true,
    logoutput   => true,
    path        => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin',
    timeout     => 300,
    require     => File["/etc/glite-ce-cream/populate_creamdb_mysql.puppet.sql"],
    subscribe   => Mysql_database["${cream_db_name}"],
  }

  exec { "populate-delegationdb":
    command     => "mysql -h localhost -u root --password=\"${mysql_password}\" ${delegation_db_name} < /etc/glite-ce-cream/populate_delegationcreamdb.puppet.sql",
    refreshonly => true,
    logoutput   => true,
    path        => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin',
    timeout     => 300,
    require     => File["/etc/glite-ce-cream/populate_delegationcreamdb.puppet.sql"],
    subscribe   => Mysql_database["${delegation_db_name}"],
  }
  
  # ##################################################################################################
  # users
  # ##################################################################################################

  $enc_std_password = mysql_password("${cream_db_password}")
  $enc_min_password = mysql_password("${cream_db_minpriv_password}")
  
  mysql_user { [ "${cream_db_user}@${access_pattern}", "${cream_db_user}@localhost" ]:
    ensure        => $ensure,
    password_hash => $enc_std_password,
    require       => Class['mysql::server'],
  }
  
  mysql_user { [ "${cream_db_minpriv_user}@${access_pattern}", "${cream_db_minpriv_user}@localhost" ]:
    ensure        => $ensure,
    password_hash => $enc_min_password,
    require       => Class['mysql::server'],
  }

  # ##################################################################################################
  # grants
  # ##################################################################################################
  
  mysql_grant { "${cream_db_user}@${access_pattern}/${cream_db_name}.*":
    privileges => 'ALL',
    user       => "${cream_db_user}@${access_pattern}",
    table      => "${cream_db_name}.*",
    require    => [ Mysql_database["${cream_db_name}"], Mysql_user["${cream_db_user}@${access_pattern}"] ],
  }

  mysql_grant { "${cream_db_user}@localhost/${cream_db_name}.*":
    privileges => 'ALL',
    user       => "${cream_db_user}@localhost",
    table      => "${cream_db_name}.*",
    require    => [ Mysql_database["${cream_db_name}"], Mysql_user["${cream_db_user}@localhost"] ],
  }

  mysql_grant { "${cream_db_user}@${access_pattern}/${delegation_db_name}.*":
    privileges => 'ALL',
    user       => "${cream_db_user}@${access_pattern}",
    table      => "${delegation_db_name}.*",
    require    => [ Mysql_database["${delegation_db_name}"], Mysql_user["${cream_db_user}@${access_pattern}"] ],
  }

  mysql_grant { "${cream_db_user}@localhost/${delegation_db_name}.*":
    privileges => 'ALL',
    user       => "${cream_db_user}@localhost",
    table      => "${delegation_db_name}.*",
    require    => [ Mysql_database["${delegation_db_name}"], Mysql_user["${cream_db_user}@localhost"] ],
  }
  
  mysql_grant { "${cream_db_minpriv_user}@${access_pattern}/${cream_db_name}.db_info":
    privileges => ['SELECT (submissionEnabled,startUpTime)'],
    options    => ['GRANT'],
    user       => "${cream_db_minpriv_user}@${access_pattern}",
    table      => "${cream_db_name}.db_info",
    require    => [ Exec["populate-creamdb"], Mysql_user["${cream_db_minpriv_user}@${access_pattern}"] ],
  }
    
  mysql_grant { "${cream_db_minpriv_user}@localhost/${cream_db_name}.db_info":
    privileges => ['SELECT (submissionEnabled,startUpTime)'],
    options    => ['GRANT'],
    user       => "${cream_db_minpriv_user}@localhost",
    table      => "${cream_db_name}.db_info",
    require    => [ Exec["populate-creamdb"], Mysql_user["${cream_db_minpriv_user}@localhost"] ],
  }

    
}
