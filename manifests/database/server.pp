class creamce::database::server (
  $package_name     = $mysql::params::server_package_name,
  $package_ensure   = 'present',
  $service_name     = $mysql::params::service_name,
  $service_provider = $mysql::params::service_provider,
  $enabled          = true,
  $mysql_password    = 'unset',
  $max_connections  = '150'
  )  inherits mysql::params {
  
  #
  # setup server and set root password
  #
  
  class {'mysql::config': 
    root_password => $mysql_password,
    old_root_password => '',
    bind_address => 'localhost',
    max_connections => $max_connections,
  }
  
  package { 'mysql-server':
    name   => $package_name,
    ensure => $package_ensure,
  }
  
  if $enabled {
    $service_ensure = 'running'
  }
  else
  {
    $service_ensure = 'stopped'
  }
  
  service { 'mysqld':
    name     => $service_name,
    ensure   => $service_ensure,
    enable   => $enabled,
    require  => Package['mysql-server'],
    provider => $service_provider,
  }
  Package['mysql-server'] -> Class['mysql::config'] -> Service['mysqld']
}
