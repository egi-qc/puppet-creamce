class creamce::apel inherits creamce::params {

  if $use_apel {
  
    package { "apel-parsers":
      ensure   => present,
    }

    file { "/etc/apel/parser.cfg":
      ensure  => present,
      owner   => "root",
      group   => "root",
      mode    => '0600',
      content => template("creamce/apel_parser.cfg.erb"),
      require => Package["apel-parsers"],
    }
    
    file { "/etc/cron.d/apelparser":
      ensure  => present,
      owner   => "root",
      group   => "root",
      mode    => '0640',
      content => "${apel_cron_sched} root /usr/bin/apelparser",
      require => File["/etc/apel/parser.cfg"],
    }
  } 
}
