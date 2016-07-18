class creamce::voms inherits creamce::params {

  #
  # Require future parser
  #
  
  # ###########################################################################
  # LSC files
  # ###########################################################################
  
  file { "${voms_dir}":
    ensure  => directory,
    owner   => "root",
    group   => "root",
    mode    => 0755,
  }
  
  each($voenv) | String $voname, Hash $value | {
  
    file { "${voms_dir}/${voname}":
      ensure  => directory,
      owner   => "root",
      group   => "root",
      mode    => 0755,
      require => File["${voms_dir}"],
    }
      
    each($value[servers]) | Hash $server | {
    
      $lscfile_content = "${server[dn]}
${server[ca_dn]}
"
    
      file { "${voms_dir}/${voname}/${server[server]}.lsc":
        ensure  => file,
        owner   => "root",
        group   => "root",
        mode    => 0644,
        content => "${lscfile_content}",
        require => File["${voms_dir}/${voname}"],
      }
      
    }
    
  }

  # ###########################################################################
  # VOMS files
  # ###########################################################################
  
  file { "/etc/vomses":
    ensure  => directory,
    owner   => "root",
    group   => "root",
    mode    => 0755,
  }
  
  each($voenv) | String $voname, Hash $value | {
    each($value[servers]) | Hash $server | {
    
      if $server.has_key(nickname) {
        $nickname = $server[nickname]
      } else {
        $nickname = $voname
      }
      
      if $server.has_key(alias) {
        $alias = $server[alias]
      }else{
        $alias = $voname
      }
    
      $vomsfile_content = "\"${nickname}\" \"${server[server]}\" \"${server[port]}\" \"${server[dn]}\" \"${alias}\" \"${server[gt_version]}\""
      
      file { "/etc/vomses/${voname}-${server[server]}":
        ensure  => file,
        owner   => "root",
        group   => "root",
        mode    => 0644,
        content => "${vomsfile_content}",
        require => File["/etc/vomses"],
      }
    
    }
  }

}
