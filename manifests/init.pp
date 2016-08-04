class creamce inherits creamce::params {
  
  if $::operatingsystem == "CentOS" and $::operatingsystemmajrelease >= 7 {
  
    include creamce::config

    if $use_argus == "false" {
        include creamce::glexec
    }

    include creamce::gridftp
    
    include creamce::gip

    include creamce::locallogger

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
    
    $glite_service_defs = "[Unit]
Description=Master service for CREAM CE
Requires=tomcat.service glite-lb-logd.service glite-ce-blah-parser.service
"

    file { "/lib/systemd/system/glite-services.target":
      ensure  => present,
      owner   => "root",
      group   => "root",
      mode    => 0644,
      content => "${glite_service_defs}",
      require => Class[Creamce::Config, Creamce::Locallogger],
    }
    
    $glite_service_refs = "[Unit]
PartOf=glite-services.target
"

    file { ["/etc/systemd/system/tomcat.service.d",
            "/etc/systemd/system/glite-ce-blah-parser.service.d",
            "/etc/systemd/system/glite-lb-logd.service.d"]:
      ensure => directory,
      owner  => "root",
      group  => "root",
      mode   => 0644,
    }

    file { [ "/etc/systemd/system/tomcat.service.d/10-glite-services.conf",
             "/etc/systemd/system/glite-ce-blah-parser.service.d/10-glite-services.conf" ]:
      ensure  => present,
      owner   => "root",
      group   => "root",
      mode    => 0644,
      content => "${glite_service_refs}",
      require => [ File["/etc/systemd/system/tomcat.service.d", 
                        "/etc/systemd/system/glite-ce-blah-parser.service.d"], 
                   Class[Creamce::Config] ],
    }

    file { "/etc/systemd/system/glite-lb-logd.service.d/10-glite-services.conf":
      ensure  => present,
      owner   => "root",
      group   => "root",
      mode    => 0644,
      content => "${glite_service_refs}",
      require => [ File["/etc/systemd/system/glite-lb-logd.service.d"],
                   Class[Creamce::Locallogger] ],
    }

  } else {
  
    # TODO
  
  }
  
}

  
  
