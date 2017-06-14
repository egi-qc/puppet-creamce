class creamce::certificate inherits creamce::params {

  if $pki_support {

    require fetchcrl
    
    file { "${host_certificate}":
      ensure   => file,
      owner    => "root",
      group    => "root",
      mode     => 0644,
      require  => Class['fetchcrl::config'],
    }

    file { "${host_private_key}":
      ensure   => file,
      owner    => "root",
      group    => "root",
      mode     => 0400,
      require  => Class['fetchcrl::config'],
    }
    
    exec { "initial_fetch_crl":
      command => "fetch-crl -l ${cacert_dir} -o ${cacert_dir} || exit 0",
      path    => "/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/sbin",
      require => Class['fetchcrl::config'],
      notify  => Class['fetchcrl::service'],
    }

  } else {

    info "PKI support is disabled; host credentials and CA certificates must be installed manually"

  }
  
}
