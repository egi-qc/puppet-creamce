class creamce::yumrepos inherits creamce::params {

  unless $cream_repo_url == "" {

    exec { "download_yumrepo":
      command => "/usr/bin/wget -q ${cream_repo_url} -O ${cream_repo}",
      creates => "${cream_repo}",
    }

    file{ "${cream_repo}":
      mode     => 0644,
      require  => Exec["download_yumrepo"],
    }

  }
  
}

