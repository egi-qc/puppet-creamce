class creamce::database::configure_privileges inherits creamce::params {
  #
  # databaseownership
  #
  database_grant{"${cream_db_user}@${cream_db_host}/${cream_db_name}":
    privileges    => ['ALL'],
  }

  database_grant{"${cream_db_user}@${cream_db_host}/${delegation_db_name}":
    privileges    => ['ALL'],
  }
  
  database_grant{"${cream_db_user}@${cream_db_host}/${information_db_name}":
    privileges    => ['ALL'],
  }
  
  database_grant{"${cream_db_minpriv_user}@${cream_db_host}/${information_db_name}":
    privileges    => ['Select_priv','Insert_priv','Update_priv','Alter_Priv','Create_Priv'],
  }
  
  database_grant{"${cream_db_minpriv_user}@${cream_db_host}/${delegation_db_name}":
    privileges    => ['Select_priv','Insert_priv','Update_priv','Alter_Priv','Create_Priv'],
  }
  
  database_grant{"${cream_db_minpriv_user}@${cream_db_host}/${cream_db_name}":
    privileges    => ['Select_priv','Insert_priv','Update_priv','Alter_Priv','Create_Priv'],
  }
  
  exec {'drop_empty_users':
    command => "/usr/bin/mysql -u root mysql -p'${mysql_password}' -e \"delete from user where Password='';flush privileges;\"",
    logoutput => true,
    path => '/bin:/usr/local/sbin:/usr/bin:/usr/local/bin',
    require => Database_grant["${cream_db_user}@${cream_db_host}/${cream_db_name}","${cream_db_minpriv_user}@${cream_db_host}/${information_db_name}","${cream_db_minpriv_user}@${cream_db_host}/${delegation_db_name}","${cream_db_minpriv_user}@${cream_db_host}/${cream_db_name}"],
  }
  
}
