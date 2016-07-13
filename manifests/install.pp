class creamce::install inherits creamce::params {

  #
  # TODO get rid of the metapackage
  #

  if $cream_repo_url == "" {

    package { "emi-cream-ce": 
      ensure   => present,
    }

  } else {
  
    exec { "download_yumrepo":
      command => "/usr/bin/wget -q ${cream_repo_url} -O ${cream_repo}",
      creates => "${cream_repo}",
    }

    file{ "${cream_repo}":
      mode     => 0644,
      require  => Exec["download_yumrepo"],
    }

    package { "emi-cream-ce": 
      ensure   => present,
      require  => Package["${cream_repo}"],
    }
    
  }  
  
}
