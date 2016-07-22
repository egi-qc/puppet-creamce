class creamce::poolaccount inherits creamce::params {

  define pooluser ($uid, $groups, $gridmapdir, $homedir="/home", $shell="/bin/bash") {
  
    user { "${title}":
      ensure     => "present",
      uid        => $uid,
      comment    => "mapped user for ${groups[0]}",
      gid        => "${groups[0]}",
      groups     => $groups,
      home       => "${homedir}/${title}",
      managehome => true,
      shell      => "${shell}"
    }
    
    file { "${gridmapdir}/${title}":
      ensure     => file,
      owner      => "root",
      group      => "root",
      mode       => 0644,
      content    => "",
      require    => [ File["${gridmapdir}"], User["${title}"] ]
    }

  }
  
  group { "edguser":
    gid    => 152,
  }
  
  file { "${gridmap_dir}":
    ensure   => directory,
    owner    => "root",
    group    => "edguser",
    mode     => 0770,
    require  => Group["edguser"],
  }
  
  $group_table = build_group_definitions($voenv)
  create_resources(group, $group_table)
  
  $user_table = build_user_definitions($voenv, $gridmap_dir)
  create_resources(pooluser, $user_table)
  
}
