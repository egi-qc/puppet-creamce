class creamce::install inherits creamce::params {

  package {"emi-cream-ce": ensure => present }
  package { "selinux-policy-targeted-emi2-gridmapdir": ensure => present}
  
  # missing dependencies ?
  package { "canl-java": ensure => present}
  package { "argus-pep-api-java": ensure => present}
  package { "delegation-java": ensure => present}
  package { "java-1.6.0-openjdk": ensure => present}
  
  class {"creamce::env":}
  class {"creamce::creamdb":}
  class {"creamce::firewall":}

  #fixme: move this to hiera
  class {'vosupport':
    supported_vos => $supported_vos,
    enable_mappings_for_service => 'ARGUS',
    enable_sudoers => True,
    enable_sandboxdir => True,
  }
  
  # Sticky Pool structure setup
  file { ['/pool', '/pool/lsf', '/pool/spool']:
    ensure  => 'directory',
    mode    => '1777',
  }
  
  case $batch_system {
    lsf: {
      class {"creamce::lsf":}
    }
    default: {
      fail "No BATCH system default defined"
    }
  }

  Package["emi-cream-ce","emi-lsf-utils","selinux-policy-targeted-emi2-gridmapdir","selinux-policy-targeted-emi2-bdii","selinux-policy-targeted-emi2-hotfixes"] -> File["/etc/gridftp.conf","/pool", "/pool/lsf", "/pool/spool"] -> Class["creamce::creamdb","creamce::firewall"] -> Class["vosupport"] ~> Service[$tomcat]

}
