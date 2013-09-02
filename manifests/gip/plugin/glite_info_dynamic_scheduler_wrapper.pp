class creamce::gip::plugin::glite_info_dynamic_scheduler_wrapper inherits creamce::params {
  #
  # /etc/lrms/scheduler.conf is batch system dependend and is created in lsf.pp for LSF
  #
  file {"$gippath/plugin/glite-info-dynamic-scheduler-wrapper":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0755,
    content => template("creamce/gip/glite-info-dynamic-scheduler-wrapper.erb"),
    #require => File["/etc/lrms/scheduler.conf"], 
  }
}
