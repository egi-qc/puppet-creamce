class creamce::gip::ldif::benchmark inherits creamce::params {
    exec {'Benchmark.ldif':
      command => "/usr/libexec/glite-ce-glue2-benchmark-static /etc/glite-ce-glue2/glite-ce-glue2.conf > $gippath/ldif/Benchmark.ldif"
    }
    file { "$gippath/ldif/ldif/Benchmark.ldif":
      mode => 0644,
      owner => "ldap",
      group => "ldap",
      require => Exec['Benchmark.ldif']
    }

}
