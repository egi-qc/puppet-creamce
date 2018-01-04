class creamce inherits creamce::params {
  
  if $::operatingsystem == "CentOS" and $::operatingsystemmajrelease in [ "7" ] {
  
    include creamce::config

    include creamce::gridftp
    
    if $use_apel {
      include creamce::apel
    } 

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
      sge: {
        include creamce::gridengine
      }
      default: {
        warning "Unsupported batch system ${batch_system}"
      }
    }

  } else {
  
    # TODO
  
  }
  
}

  
  
