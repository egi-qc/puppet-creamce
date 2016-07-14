class creamce::install inherits creamce::params {

  require creamce::yumrepos
  require creamce::tomcat

  package { ["glite-ce-cream", "glite-ce-blahp", "mysql-connector-java", "apel-parsers", "cleanup-grid-accounts"]: 
    ensure   => present,
  }
    
}



