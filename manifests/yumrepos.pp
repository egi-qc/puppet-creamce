class creamce::yumrepos inherits creamce::params {

  define getyumrepo ($yum_repo_dir, $cream_repo_url=$title) {
    
    $tmpl = split($cream_repo_url, '.')
    if $tmpl[-1] == "repo" {
      $tmpl = split($cream_repo_url, '/')
      $cream_repo = $tmpl[-1]
    } else {
      $tmps = digest($cream_repo_url)
      $cream_repo = "creamrepo_${tmps}.repo" 
    }

    exec { "download_${cream_repo}":
      command => "/usr/bin/wget -q  -P ${yum_repo_dir} ${cream_repo_url}",
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

