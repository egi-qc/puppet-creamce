# puppet-creamce

puppet module to install and configure a cream CE (EMI3)


## YAML configuration

Example of mininal configuration:
```
---
mysql_password :            mysqlp@$$w0rd
cream_db_password :         creamp@$$w0rd
cream_db_minpriv_password : minp@$$w0rd
apel_dbpass :               apelp@$$w0rd
batch_system :              pbs
use_argus :                 false

grid_queues :
    long :  { 
        groups : [ dteam, dteamprod ]
    }
    short : {
        groups : [ dteamsgm ]
    }

voenv :
    dteam : { 
        voname : dteam, 
        vo_sw_dir : /afs/dteam, 
        vo_app_dir : /var/lib/vo/dteam, 
        vo_default_se : storage.pd.infn.it,
        servers : [
                      {
                          server : voms.cern.ch,
                          port : 15002,
                          dn : /DC=ch/DC=cern/OU=computers/CN=voms.cern.ch,
                          ca_dn : /DC=ch/DC=cern/CN=CERN Trusted Certification Authority,
                          gt_version : 24
                      },
                      {
                          server : lcg-voms.cern.ch,
                          port : 15002,
                          dn : /DC=ch/DC=cern/OU=computers/CN=lcg-voms.cern.ch,
                          ca_dn : /DC=ch/DC=cern/CN=CERN Trusted Certification Authority,
                          gt_version : 24
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

subclusters :
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

se_list :
    storage.pd.infn.it : { mount_dir : "/data/mount", export_dir : "/storage/export", type : Storm }
    cloud.pd.infn.it : { mount_dir : "/data/mount", export_dir : "/storage/export",  type : Dcache }

ce_capability : [ "CloudSupport=false", "Multinode=true" ]

cream_repo_urls : [ "http://igi-01.pd.infn.it/mrepo/grid-dev/rpms/repos/centos7/emi-all.repo" ]

gridftp::params::certificate : "/etc/grid-security/hostcert.pem"
gridftp::params::key : "/etc/grid-security/hostkey.pem"
gridftp::params::port : 2811

```

