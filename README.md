# puppet-creamce

puppet module to install and configure a cream CE (EMI3)


## YAML configuration Parameters

**creamce::site::name** (_string_): 
**creamce::site::email** (_string_):
**creamce::host** (_string_):
**creamce::port** (_integer_):
**creamce::type** (_string_):
**creamce::quality_level** (_string_):
**creamce::environment** (_hash_):
**creamce::mysql::access_by_domain** (_boolean_):
**creamce::mysql::override_options** (_hash_):
**creamce::mysql::root_password** (_string_):
**creamce::mysql::max_active** (_integer_):
**creamce::mysql::min_idle** (_integer_):
**creamce::mysql::max_wait** (_integer_):
**creamce::creamdb::name** (_string_):
**creamce::creamdb::user** (_string_):
**creamce::creamdb::password** (_string_):
**creamce::creamdb::host** (_string_):
**creamce::creamdb::port** (_integer_):
**creamce::creamdb::domain** (_string_):
**creamce::creamdb::minpriv_user** (_string_):
**creamce::creamdb::minpriv_password** (_string_):
**creamce::delegationdb::name** (_string_):
**creamce::sandbox_path** (_string_):
**creamce::enable_limiter** (_boolean_):
**creamce::limit::load1** (_integer_):
**creamce::limit::load5** (_integer_):
**creamce::limit::load15** (_integer_):
**creamce::limit::memusage** (_integer_):
**creamce::limit::swapusage** (_integer_):
**creamce::limit::fdnum** (_integer_):
**creamce::limit::diskusage** (_integer_):
**creamce::limit::ftpconn** (_integer_):
**creamce::limit::fdtomcat** (_integer_):
**creamce::limit::activejobs** (_integer_):
**creamce::limit::pendjobs** (_integer_):
**creamce::queue_size** (_integer_):
**creamce::workerpool_size** (_integer_):
**creamce::blah_timeout** (_integer_):
**creamce::listener_port** (_integer_):
**creamce::job_purge_rate** (_integer_):
**creamce::blp::retry_delay** (_integer_):
**creamce::blp::retry_count** (_integer_):
**creamce::lease::time** (_integer_):
**creamce::lease::rate** (_integer_):
**creamce::smp_size** (_integer_):
**creamce::purge::aborted** (_integer_):
**creamce::purge::cancel** (_integer_):
**creamce::purge::done** (_integer_):
**creamce::purge::failed** (_integer_):
**creamce::purge::register** (_integer_):
**creamce::delegation::purge_rate** (_integer_):
**creamce::jw::deleg_time_slot** (_integer_):
**creamce::jw::proxy_retry_wait** (_integer_):
**creamce::jw::retry::count_isb** (_integer_):
**creamce::jw::retry::wait_isb** (_integer_):
**creamce::jw::retry::count_osb** (_integer_):
**creamce::jw::retry::wait_osb** (_integer_):
**creamce::gridenvfile::sh** (_string_):
**creamce::gridenvfile::csh** (_string_):
**creamce::cga::logfile** (_string_):
**creamce::cga::cron_sched** (_string_):
**creamce::at_deny_extras** (_list_):
**creamce::cron_deny_extras** (_list_):
**creamce::sudo_logfile** (_string_):
**creamce::default_pool_size** (_integer_):


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

