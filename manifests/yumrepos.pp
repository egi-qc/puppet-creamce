class creamce::yumrepos inherits creamce::params {

  define getyumrepo ($yum_repo_dir, $cream_repo_url=$title) {
    
    $cream_repo = get_repo_name($cream_repo_url)

    exec { "download_${cream_repo}":
      command => "/usr/bin/wget -q  -O ${yum_repo_dir}/${cream_repo} ${cream_repo_url}",
      creates => "${yum_repo_dir}/${cream_repo}",
    }
 
  }

  if size($cream_repo_urls) > 0 {

    getyumrepo { $cream_repo_urls:
      yum_repo_dir  => "/etc/yum.repos.d",
    }

  }

  package { "redhat-lsb-core":
    ensure   => present,
  }

}

