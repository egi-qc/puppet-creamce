class creamce inherits creamce::params {
  
  if $::operatingsystem == "CentOS" and $::operatingsystemmajrelease in [ "7" ] {
  
    include creamce::config

    unless $use_argus {
        include creamce::glexec
    }

    include creamce::gridftp
    
    include creamce::gip
    
    include creamce::apel

    if $use_loclog {
      include creamce::locallogger
    }

    #
    # Batch system support
    #
    case $batch_system {
      condor: {
        include creamce::condor
      }
      lsf: {
        include creamce::lsf
      }
      pbs: {
        include creamce::torque
      }
      slurm: {
        include creamce::slurm
      }
      default: {
        warning "No package installed for lrms infoprovider"
      }
    }
    
    #
    # Virtual master service for systemd
    #
    
    if $use_loclog {
      $glite_service_defs = "[Unit]
Description=Master service for CREAM CE
Requires=tomcat.service glite-ce-blah-parser.service glite-lb-logd.service glite-lb-interlogd.service
"
    } else {
      $glite_service_defs = "[Unit]
Description=Master service for CREAM CE
Requires=tomcat.service glite-ce-blah-parser.service
"
    }

    $glite_service_refs = "[Unit]
PartOf=glite-services.target
"
    $blah_systemddir = "/etc/systemd/system/glite-ce-blah-parser.service.d"
    $tomcat_systemddir = "/etc/systemd/system/tomcat.service.d"

    file { ["${tomcat_systemddir}", "${blah_systemddir}"]:
      ensure => directory,
      owner  => "root",
      group  => "root",
      mode   => '0644',
    }
    
    file { "/lib/systemd/system/glite-services.target":
      ensure  => present,
      owner   => "root",
      group   => "root",
      mode    => '0644',
      content => "${glite_service_defs}",
    }  
    if $use_loclog {
      Class[Creamce::Config, Creamce::Locallogger] -> File["/lib/systemd/system/glite-services.target"]
    } else {
      Class[Creamce::Config] -> File["/lib/systemd/system/glite-services.target"]
    }
    
    file { "${tomcat_systemddir}/10-glite-services.conf":
      ensure  => present,
      owner   => "root",
      group   => "root",
      mode    => '0644',
      content => "${glite_service_refs}",
    }
    File["${tomcat_systemddir}"] -> File["${tomcat_systemddir}/10-glite-services.conf"]
    Class[Creamce::Config] -> File["${tomcat_systemddir}/10-glite-services.conf"]
    
    file { "${blah_systemddir}/10-glite-services.conf":
      ensure  => present,
      owner   => "root",
      group   => "root",
      mode    => '0644',
      content => "${glite_service_refs}",
    }
    File["${blah_systemddir}"] -> File["${blah_systemddir}/10-glite-services.conf"]
    case $batch_system {
      condor: {
        Class[Creamce::Condor] -> File["${blah_systemddir}/10-glite-services.conf"]
      }
      lsf: {
        include creamce::lsf
        Class[Creamce::Lsf] -> File["${blah_systemddir}/10-glite-services.conf"]
      }
      pbs: {
        include creamce::torque
        Class[Creamce::Torque] -> File["${blah_systemddir}/10-glite-services.conf"]
      }
      slurm: {
        include creamce::slurm
        Class[Creamce::Slurm] -> File["${blah_systemddir}/10-glite-services.conf"]
      }
    }
    
    if $use_loclog {

      file { ["/etc/systemd/system/glite-lb-logd.service.d",
              "/etc/systemd/system/glite-lb-interlogd.service.d"]:
        ensure => directory,
        owner  => "root",
        group  => "root",
        mode   => '0644',
      }

      file { "/etc/systemd/system/glite-lb-logd.service.d/10-glite-services.conf":
        ensure  => present,
        owner   => "root",
        group   => "root",
        mode    => '0644',
        content => "${glite_service_refs}",
        require => [ File["/etc/systemd/system/glite-lb-logd.service.d"], Class[Creamce::Locallogger] ],
      }
    
      file { "/etc/systemd/system/glite-lb-interlogd.service.d/10-glite-services.conf":
        ensure  => present,
        owner   => "root",
        group   => "root",
        mode    => '0644',
        content => "${glite_service_refs}",
        require => [ File["/etc/systemd/system/glite-lb-interlogd.service.d"], Class[Creamce::Locallogger] ],
      }

    }

  } else {
  
    # TODO
  
  }
  
}

  
  
