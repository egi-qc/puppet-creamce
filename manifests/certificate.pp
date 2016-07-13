class creamce::certificate inherits creamce::params {

  exec { "download_yumrepo":
    command => "/usr/bin/wget -q ${eugridpma_repo_url} -O ${eugridpma_repo}",
    creates => "/etc/yum.repos.d/${eugridpma_repo}",
  }

  file{ "${eugridpma_repo}":
    mode => 0644,
    require => Exec["download_yumrepo"],
  }
  
  package { "ca-policy-egi-core":
    ensure    => present,
    require   => File["${eugridpma_repo}"],
  }
  
  package { "fetch-crl":
    ensure    => present,
    require   => File["${eugridpma_repo}"],
  }
  
  file { "${host_certificate}":
    ensure => file,
    owner => "root",
    group => "root",
    mode => 0644,
  }

  file { "${host_private_key}":
    ensure => file,
    owner => "root",
    group => "root",
    mode => 0400,
  }
  
  service { "fetch-crl-cron":
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    alias      => "fetch-crl-cron",
    require    => Package["ca-policy-egi-core", "fetch-crl"],
  }

}
