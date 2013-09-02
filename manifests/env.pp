class creamce::env inherits creamce::params {

  concat{$gridenvfile:
    owner =>  'root',
    group =>  'root',
    mode  =>  '0755',
    warn => "# $gridenvfile is managed by Puppet env.pp.\n#Any changes in here will be overwritten",         
  }
  concat::fragment{"grid-env header": 
    target  => $gridenvfile,
    order   => '01',
    content => template('creamce/gridenvsh_header.erb')
  }
  concat::fragment{"grid-env footer": 
    target  => $gridenvfile,
    order   => '99',
    content => template('creamce/gridenvsh_footer.erb')
  }

  concat::fragment{"grid-env contents": 
    target  => $gridenvfile,
    order   => '50',
    content => template('creamce/gridenvsh_contents.erb')
  }
  
  file {"/etc/profile.d/grid-env.csh":
    ensure => present,
    content => template("creamce/gridenvcsh.erb"),
    owner => "root",
    group => "root",
    mode => 0644,
  }  
}
