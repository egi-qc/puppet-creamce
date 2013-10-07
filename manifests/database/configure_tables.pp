class creamce::database::configure_tables inherits creamce::params {
  #
  # create tables
  #
  exec {"Setup cream db":
    command => "/bin/sh /usr/bin/createAndPopulateDB.sh root ${cream_db_password} ${cream_db_name} ${cream_db_version} 'N' /etc/glite-ce-cream/populate_creamdb_mysql.tmp.sql ${cream_db_host} ${cream_sandbox_path}",
    loglevel => notice,
  }
  exec {"Setup delegation db":
    command => "/bin/sh /usr/bin/createAndPopulateDB.sh root ${cream_db_password} ${delegation_db_name} ${delegation_db_version} 'N' /etc/glite-ce-cream/populate_delegationcreamdb.tmp.sql ${cream_db_host}",
    loglevel => notice,
  }
}
