class creamce::database::configure_users inherits params {
  #
  # users
  #
  database_user{"${cream_db_user}@${::fqdn}":
    password_hash => mysql_password("${cream_db_password}"),
  }
  
  database_user{"${cream_db_minpriv_user}@${::fqdn}":
    password_hash => mysql_password("${cream_db_minpriv_password}"),
  }
  
  database_user{"${cream_db_user}@localhost":
    password_hash => mysql_password("${cream_db_password}"),
  }
  
  database_user{"${cream_db_minpriv_user}@localhost":
    password_hash => mysql_password("${cream_db_minpriv_password}"),
  }

}
