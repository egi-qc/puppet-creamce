class creamce::database::configure_users (
  $host_pattern = "${cream_db_host}",
) inherits params {

  $enc_std_password = mysql_password("${cream_db_password}")
  $enc_min_password = mysql_password("${cream_db_minpriv_password}")
  
  mysql_user { "${cream_db_user}@${host_pattern}":
    ensure        => $ensure,
    password_hash => $enc_std_password,
  }
  
  mysql_user { "${cream_db_user}@localhost":
    ensure        => $ensure,
    password_hash => $enc_std_password,
  }
  
  mysql_user { "${cream_db_minpriv_user}@${host_pattern}":
    ensure        => $ensure,
    password_hash => $enc_min_password,
  }

  mysql_user { "${cream_db_minpriv_user}@localhost":
    ensure        => $ensure,
    password_hash => $enc_min_password,
  }
  
}
