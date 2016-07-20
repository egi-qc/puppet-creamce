class creamce::voms inherits creamce::params {

  file { "/etc/vomses":
    ensure  => directory,
    owner   => "root",
    group   => "root",
    mode    => 0755,
  }
  
  file { "${voms_dir}":
    ensure  => directory,
    owner   => "root",
    group   => "root",
    mode    => 0755,
  }
  
  define vofiles ($server, $port, $dn, $ca_dn, $gtversion, $voname, $vodir) {
  
    $lscfile_content = "${dn}\n${ca_dn}\n"
    file { "${vodir}/${voname}/${server}.lsc":
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => 0644,
      content => "${lscfile_content}",
      require => File["${vodir}/${voname}"],
    }
    
    # maybe we can use the voname for nickname
    $nickname = $title
    
    $vomsfile_content = "\"${nickname}\" \"${server}\" \"${port}\" \"${dn}\" \"${voname}\" \"${gtversion}\"\n"
    file { "/etc/vomses/${voname}-${server}":
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => 0644,
      content => "${vomsfile_content}",
      require => File["/etc/vomses"],
    }    
    
  }
  
  $vopaths = prefix(keys($voenv), "${voms_dir}/")
  file { "$vopaths":
    ensure  => directory,
    owner   => "root",
    group   => "root",
    mode    => 0755,
    require => File["${voms_dir}"],
  }
  
  $vo_table = build_vo_definitions($voenv, "${voms_dir}")
  create_resources(vofiles, $vo_table)

}
