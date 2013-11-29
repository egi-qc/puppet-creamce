class creamce::nfs inherits creamce::params {
  
  package{['nfs-utils']:
    ensure => present,
  }
  
  #make sure the rpcbind and nfslock services are started prior to mounting the NFS share!
  #NB: this is for SLC6, on SLC5 we would need portmap instead of rpcbind. See cvmfs for an example.
  service { ['rpcbind','nfslock']:
    ensure => 'running',    
    enable => true,
    hasrestart => true,
    hasstatus => true,  
  }

  #Use autofs so that the NFS share is correctly mounted on startup and argus directly uses it 
  #We use a direct mount declared in a mapfile auto.info-dynamic-cache
  autofs::mount { '/-':
    map     => 'file:/etc/auto.info-dynamic-cache',
  }
  autofs::mount { '/opt/edg/var/nfs':
    map     => 'file:/etc/auto.info',
  }
  file {'/var/cache/info-dynamic-lsf':
    ensure => directory,
    owner  => 'tomcat',
    group  => 'ldap',
    mode   => '2770',
  }    
  file {'/opt/edg/var/nfs':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
  file {'/opt/edg/var/info':
    ensure => link,
    target => "/opt/edg/var/nfs/info/info${lsbmajdistrelease}",
  }
  #the automount maps are not managed by the autofs module (only master map and included master maps are)
  file { '/etc/auto.info-dynamic-cache':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    content => "/var/cache/info-dynamic-lsf $nfs_options ${nfs_server_cachedir}:${nfs_remote_cachedir}",
  }
  file { '/etc/auto.info':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    content => "info $nfs_options ${nfs_server_infodir}:${nfs_remote_infodir}",
  }
    
  #Of course, make sure this is set up before argus is up and running.
  #auto.gridmapdir being a direct maps, any change should notify the autofs service.
  Package['nfs-utils'] -> Service['rpcbind','nfslock'] -> File['/etc/auto.info-dynamic-cache','/etc/auto.info','/var/cache/info-dynamic-lsf'] -> Service['autofs'] -> Service[$tomcat]

}
