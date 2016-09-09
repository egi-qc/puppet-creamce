# puppet-creamce

puppet module to install and configure a cream CE (EMI3)


## YAML configuration Parameters

### CREAM service
* **creamce::host** (_string_): TODO, default the host name
* **creamce::port** (_integer_): TODO, default 8443
* **creamce::quality_level** (_string_): TODO, default "production"
* **creamce::environment** (_hash_): TODO, default empty hash
* **creamce::mysql::access_by_domain** (_boolean_): TODO, default false
* **creamce::mysql::override_options** (_hash_): TODO, default "`{'mysqld' => {'bind-address' => '0.0.0.0', 'max_connections' => "450" }}`"
* **creamce::mysql::root_password** (_string_): TODO, **mandatory**
* **creamce::mysql::max_active** (_integer_): TODO, default 200
* **creamce::mysql::min_idle** (_integer_): TODO, default 30
* **creamce::mysql::max_wait** (_integer_): TODO, default 10000
* **creamce::creamdb::name** (_string_): TODO, default "creamdb"
* **creamce::creamdb::user** (_string_): TODO, default "cream"
* **creamce::creamdb::password** (_string_): TODO, **mandatory**
* **creamce::creamdb::host** (_string_): TODO, default the host name
* **creamce::creamdb::port** (_integer_): TODO, default 3306
* **creamce::creamdb::domain** (_string_): TODO, default the local domain name
* **creamce::creamdb::minpriv_user** (_string_): TODO, default "minprivuser"
* **creamce::creamdb::minpriv_password** (_string_): TODO, **mandatory**
* **creamce::delegationdb::name** (_string_): TODO, default "delegationcreamdb"
* **creamce::sandbox_path** (_string_): TODO, default "/var/cream_sandbox"
* **creamce::enable_limiter** (_boolean_): TODO, default true
* **creamce::limit::load1** (_integer_): TODO, default 400
* **creamce::limit::load5** (_integer_): TODO, default 400
* **creamce::limit::load15** (_integer_): TODO, default 200
* **creamce::limit::memusage** (_integer_): TODO, default 95
* **creamce::limit::swapusage** (_integer_): TODO, default 95
* **creamce::limit::fdnum** (_integer_): TODO, default 5000
* **creamce::limit::diskusage** (_integer_): TODO, default 95
* **creamce::limit::ftpconn** (_integer_): TODO, default 500
* **creamce::limit::fdtomcat** (_integer_): TODO, default 8000
* **creamce::limit::activejobs** (_integer_): TODO, default -1
* **creamce::limit::pendjobs** (_integer_): TODO, default -1
* **creamce::queue_size** (_integer_): TODO, default 500
* **creamce::workerpool_size** (_integer_): TODO, default 50
* **creamce::blah_timeout** (_integer_): TODO, default 300
* **creamce::listener_port** (_integer_): TODO, default 49152
* **creamce::job_purge_rate** (_integer_): TODO, default 300
* **creamce::blp::retry_delay** (_integer_): TODO, default 60000
* **creamce::blp::retry_count** (_integer_): TODO, default 100
* **creamce::lease::time** (_integer_): TODO, default 36000
* **creamce::lease::rate** (_integer_): TODO, default 30
* **creamce::smp_size** (_integer_): TODO, default 8
* **creamce::purge::aborted** (_integer_): TODO, default 10
* **creamce::purge::cancel** (_integer_): TODO, default 10
* **creamce::purge::done** (_integer_): TODO, default 10
* **creamce::purge::failed** (_integer_): TODO, default 10
* **creamce::purge::register** (_integer_): TODO, default 2
* **creamce::delegation::purge_rate** (_integer_): TODO, default 720
* **creamce::jw::deleg_time_slot** (_integer_): TODO, default 3600
* **creamce::jw::proxy_retry_wait** (_integer_): TODO, default 60
* **creamce::jw::retry::count_isb** (_integer_): TODO, default 2
* **creamce::jw::retry::wait_isb** (_integer_): TODO, default 60
* **creamce::jw::retry::count_osb** (_integer_): TODO, default 2
* **creamce::jw::retry::wait_osb** (_integer_): TODO, default 300
* **creamce::gridenvfile::sh** (_string_): TODO, default "/etc/profile.d/grid-env.sh"
* **creamce::gridenvfile::csh** (_string_): TODO, default "/etc/profile.d/grid-env.csh"
* **creamce::cga::logfile** (_string_): TODO, default "/var/log/cleanup-grid-accounts.log"
* **creamce::cga::cron_sched** (_string_): TODO, default "30 1 * * *"
* **creamce::at_deny_extras** (_list_): TODO, default empty list
* **creamce::cron_deny_extras** (_list_): TODO, default empty list
* **creamce::sudo_logfile** (_string_): TODO, default syslog
* **creamce::default_pool_size** (_integer_): TODO, default 100
* **creamce::site::name** (_string_): TODO, default the host name
* **creamce::site::email** (_string_): TODO, default undefined
* **creamce::batch_system** (_string_): TODO, **mandatory**

### BLAH
* **blah::config_file** (_string_): TODO, default "/etc/blah.config"
* **blah::child_poll_timeout** (_integer_): TODO, default 200
* **blah::alldone_interval** (_integer_): TODO, default 86400
* **blah::use_blparser** (_boolean_): TODO, default false
* **blah::blp::host** (_string_): TODO, default undefined
* **blah::blp::port** (_integer_): TODO, default 33333
* **blah::blp::num** (_integer_): TODO, default 1
* **blah::blp::host1** (_string_): TODO, default undefined
* **blah::blp::port1** (_integer_): TODO, default 33334
* **blah::blp::host2** (_string_): TODO, default undefined
* **blah::blp::port2** (_integer_): TODO, default 33335
* **blah::blp::cream_port** (_integer_): TODO, default 56565
* **blah::check_children** (_integer_): TODO, default 30
* **blah::logrotate::interval** (_integer_): TODO, default 365
* **blah::logrotate::size** (_string_): TODO, default "10M"
* **blah::bupdater::loop_interval** (_integer_): TODO, default 30
* **blah::bupdater::notify_port** (_integer_): TODO, default 56554
* **blah::bupdater::purge_interval** (_integer_): TODO, default 2500000
* **blah::bupdater::logrotate::interval** (_integer_): TODO, default 50
* **blah::bupdater::logrotate::size** (_string_): TODO, default "10M"

Example of mininal configuration:
```
---
creamce::mysql::root_password :            mysqlp@$$w0rd
creamce::creamdb::password :               creamp@$$w0rd
creamce::creamdb::minpriv_password :       minp@$$w0rd
apel::db::pass :                           apelp@$$w0rd
creamce::batch_system :                    pbs
creamce::use_argus :                       false
creamce::default_pool_size :               10

creamce::queues :
    long :  { 
        groups : [ dteam, dteamprod ]
    }
    short : {
        groups : [ dteamsgm ]
    }

creamce::vo_table :
    dteam : { 
        voname : dteam, 
        vo_sw_dir : /afs/dteam, 
        vo_app_dir : /var/lib/vo/dteam, 
        vo_default_se : storage.pd.infn.it,
        servers : [
                      {
                          server : voms.hellasgrid.gr,
                          port : 15004,
                          dn : /C=GR/O=HellasGrid/OU=hellasgrid.gr/CN=voms.hellasgrid.gr,
                          ca_dn : "/C=GR/O=HellasGrid/OU=Certification Authorities/CN=HellasGrid CA 2016"
                      },
                      {
                          server : voms2.hellasgrid.gr,
                          port : 15004,
                          dn : /C=GR/O=HellasGrid/OU=hellasgrid.gr/CN=voms2.hellasgrid.gr,
                          ca_dn : "/C=GR/O=HellasGrid/OU=Certification Authorities/CN=HellasGrid CA 2016"
                      }
        ],
        groups : {
            dteam : {
                fqan : [ "/dteam" ],
                gid : 9000
            },
            dteamsgm : {
                fqan : [ "/dteam/sgm/ROLE=developer" ],
                gid : 9001,
                pub_admin : true
            },
            dteamprod : {
                fqan : [ "/dteam/prod/ROLE=developer" ],
                gid : 9002
            }
        },
        users : {
            dteamusr : {
                first_uid : 6000,
                groups : [ dteam ]
            },
            dteamsgmusr : {
                first_uid : 6100,
                pool_size : 5,
                groups : [ dteamsgm, dteam ]
            },
            dteamprodusr : {
                first_uid : 6200,
                pool_size : 5,
                groups : [ dteamprod, dteam ]
            }
        }
    }

creamce::hardware_table :
    subcluster001 : {
        ce_cpu_model : XEON,
        ce_cpu_speed : 2500,
        ce_cpu_vendor : Intel,
        ce_cpu_version : 5.1,
        ce_physcpu : 2,
        ce_logcpu : 2,
        ce_physcpu_perhost : 2,
        ce_logcpu_perhost : 2,
        ce_cores : 2,
        ce_minphysmem : 2048,
        ce_minvirtmem : 4096,
        ce_os_family : "%{::osfamily}",
        ce_os_arch : "%{::architecture}",
        ce_os_release : "%{::operatingsystemrelease}",
        ce_os_version : "%{::operatingsystemmajrelease}",
        ce_os_name : "%{::operatingsystem}",
        ce_otherdescr : "Cores=2,Benchmark=3-HEP-SPEC06",
        ce_outboundip : true,
        ce_inboundip : false,
        ce_smpsize : 2,
        ce_runtimeenv : [ SI00MeanPerCPU_870, SF00MeanPerCPU_790, MPICH, MPI_HOME_NOTSHARED ],
        subcluster_tmpdir : /var/tmp/subcluster001,
        subcluster_wntmdir : /var/glite/subcluster001,
        ce_benchmarks : {
            specfp2000 : 420,
            specint2000 : 380,
            hep-spec06 : 780
        },
        nodes : [ "node-01.test.pd.infn.it" ]
    }

creamce::se_table :
    storage.pd.infn.it : { mount_dir : "/data/mount", export_dir : "/storage/export", type : Storm }
    cloud.pd.infn.it : { mount_dir : "/data/mount", export_dir : "/storage/export",  type : Dcache }

creamce::info::capability : [ "CloudSupport=false", "Multinode=true" ]

creamce::repo_urls : [ "http://igi-01.pd.infn.it/mrepo/grid-dev/rpms/repos/centos7/emi-all.repo" ]

gridftp::params::certificate : "/etc/grid-security/hostcert.pem"
gridftp::params::key : "/etc/grid-security/hostkey.pem"
gridftp::params::port : 2811

```

