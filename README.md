# puppet-creamce

puppet module to install and configure a cream CE


## YAML configuration Parameters

### CREAM service
* **creamce::batch_system** (_string_): The installed batch system, **mandatory**, one of "pbs", "slurm", "condor", "lsf"
* **creamce::host** (_string_): The fully qualified Computing Element host name, default the host name
* **creamce::port** (_integer_): The tomcat listen port, default 8443
* **creamce::quality_level** (_string_): The service level of the Computing Element, default "production"
* **creamce::environment** (_hash_): The environment variables passed to the CE, default empty hash
* **creamce::sandbox_path** (_string_): The directory where the sandbox files are staged on the CREAM CE node, default "/var/cream_sandbox"
* **creamce::enable_limiter** (_boolean_): In order to disable the limiter, it is needed to set this parameter value to false and restart the service, default true
* **creamce::limit::load1** (_integer_): Limiter threshold for the load average (1 minute), default 40
* **creamce::limit::load5** (_integer_): Limiter threshold for the load average (5 minute), default 40
* **creamce::limit::load15** (_integer_): Limiter threshold for the load average (15 minute), default 20
* **creamce::limit::memusage** (_integer_): Limiter threshold for the memory usage, default 95 (percentage)
* **creamce::limit::swapusage** (_integer_): Limiter threshold for the swap usage, default 95 (percentage)
* **creamce::limit::fdnum** (_integer_): Limiter threshold for the number of file descriptors, default 500
* **creamce::limit::diskusage** (_integer_): Limiter threshold for the disk usage, default 95 (percentage)
* **creamce::limit::ftpconn** (_integer_): Limiter threshold for the number of concurrent ftp connections, default 30
* **creamce::limit::fdtomcat** (_integer_): Limiter threshold for the number of file descriptors, default 800
* **creamce::limit::activejobs** (_integer_): Limiter threshold for the number of active jobs, default -1 (unlimited)
* **creamce::limit::pendjobs** (_integer_): Limiter threshold for the number of pending jobs, default -1 (unlimited)
* **creamce::blah_timeout** (_integer_): Represents the maximum time interval in seconds accepted by CREAM for the execution of commands by BLAH, default 300 seconds
* **creamce::listener_port** (_integer_): The port used by CREAM to receive notifications about job status changes sent by the BLParser/JobWrapper, default 49152
* **creamce::job_purge_rate** (_integer_): Specifies in minutes how often the job purger has to run, default 300 minutes.
* **creamce::blp::retry_delay** (_integer_): The time interval in seconds between two attempts to contact the BLAH parser, default 60 seconds
* **creamce::blp::retry_count** (_integer_): Represents the number of attempts to contact the BLAH parser (if it is not reachable) before giving up.
If -1 is specified, CREAM will never give up , default 100
* **creamce::lease::time** (_integer_): The maximum allowed lease time in second. 
If a client specifies a lease time too big, this value is used instead, default 36000 seconds.
* **creamce::lease::rate** (_integer_): Specifies in minutes how often the job purger has to run, default 30 minutes
* **creamce::purge::aborted** (_integer_): Specifies in days how often the job purger deletes the aborted jobs, default 10 days
* **creamce::purge::cancel** (_integer_): Specifies in days how often the job purger deletes the cancelled jobs, default 10 days
* **creamce::purge::done** (_integer_): Specifies in days how often the job purger deletes the executed jobs, default 10 days
* **creamce::purge::failed** (_integer_): Specifies in days how often the job purger deletes the failed jobs, default 10 days
* **creamce::purge::register** (_integer_): Specifies in days how often the job purger deletes the registered jobs, default 2 days
* **creamce::delegation::purge_rate** (_integer_): specifies how often the delegation purger has to run, default 10 minutes
* **creamce::jw::proxy_retry_wait** (_integer_): The minimum time interval expressed in seconds, between the first attempt
and the second one for retrieving the user delegation proxy, default 60
* **creamce::jw::isb::retry_count** (_integer_): The maximum number of ISB file transfers that should be tried, default 2
* **creamce::jw::isb::retry_wait** (_integer_):  If during a input sandbox file transfer occurs a failure, the JW retries the operation after a while.
The sleep time between the first attempt and the second one is the “initial wait time”
(i.e. the wait time between the first attempt and the second one) expressed in seconds. In every next attempt the sleep time is doubled. Default 60 seconds.
* **creamce::jw::osb::retry_count** (_integer_): The maximum number of ISB file transfers that should be tried, default 2
* **creamce::jw::osb::retry_wait** (_integer_): If during a output sandbox file transfer occurs a failure, the JW retries the operation after a while.
The sleep time between the first attempt and the second one is the “initial wait time”
(i.e. the wait time between the first attempt and the second one) expressed in seconds. In every next attempt the sleep time is doubled. Default 300 seconds.
* **creamce::gridenvfile::sh** (_string_): The path of the environment definitions (standard shell), default "/etc/profile.d/grid-env.sh"
* **creamce::gridenvfile::csh** (_string_): The path of the environment definitions (korn shell), default "/etc/profile.d/grid-env.csh"
* **creamce::cga::logfile** (_string_): The path of the log file for grid account cleaner, default "/var/log/cleanup-grid-accounts.log"
* **creamce::cga::cron_sched** (_string_): The time parameters for the grid account cleaner cron script, default "30 1 * * *"
* **creamce::at_deny_extras** (_list_): Extra items to be inserted into the ban list for the command at, default empty list
* **creamce::cron_deny_extras** (_list_): Extra items to be inserted into the ban list for cron, default empty list
* **creamce::sudo_logfile** (_string_): The path of the log file for sudo, default empty string (log on syslog)
* **creamce::default_pool_size** (_integer_): The default number of users in a pool account, used if **pool_size** is not define for a VO group, default 100
* **creamce::site::name** (_string_): The human-readable name of your site., default the host name
* **creamce::site::email** (_string_): The main email contact for the site. The syntax is a coma separated list of email addresses, default undefined

### CREAM Database
* **creamce::mysql::root_password** (_string_): root password for the database administrator, **mandatory**
* **creamce::creamdb::password** (_string_): The database user password for the main operator, **mandatory**
* **creamce::creamdb::minpriv_password** (_string_): The database user password for the monitor agent, **mandatory**
* **creamce::mysql::max_active** (_integer_): TODO, default 200
* **creamce::mysql::min_idle** (_integer_): TODO, default 30
* **creamce::mysql::max_wait** (_integer_): TODO, default 10000
* **creamce::mysql::override_options** (_hash_): see the override option defined in https://forge.puppet.com/puppetlabs/mysql,
default "`{'mysqld' => {'bind-address' => '0.0.0.0', 'max_connections' => "450" }}`"
* **creamce::creamdb::name** (_string_): The database name for the CREAM service, default "creamdb"
* **creamce::creamdb::user** (_string_): The database user name with user acting as main operator, default "cream"
* **creamce::creamdb::host** (_string_): The fully qualified host name for any CE databases, default the host name
* **creamce::creamdb::port** (_integer_): The mysql listen port for any CE databases, default 3306
* **creamce::creamdb::minpriv_user** (_string_): The database user name with user acting as monitor agent, default "minprivuser"
* **creamce::delegationdb::name** (_string_): The database name for the Delegation Service, default "delegationcreamdb"

### BLAH
* **blah::config_file** (_string_): The path of the main BLAH configuration file, default "/etc/blah.config"
* **blah::child_poll_timeout** (_integer_): TODO, default 200
* **blah::alldone_interval** (_integer_): TODO, default 86400
* **blah::use_blparser** (_boolean_): If true it enables the BLParser service otherwise BUpdater/BNotifier is used, default false
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
* **blah::bupdater::logrotate::size** (_string_): The size of a log file in MB, default "10M"

### CREAM information system
* **bdii::params::user** (_string_): The local user running the BDII service, default "ldap"
* **bdii::params::group** (_string_): The local group running the BDII service, default "ldap"
* **bdii::params::port** (_integer_): The BDII service port, default 2170
* **creamce::hardware_table** (_hash_): see the section "Hardware table" for further details, default empty hash
* **creamce::info::capability** (_list_): The list of capability for a CREAM site; it's a list of string,
in general with format "name=value", default empty list
* **creamce::se_table** (_hash_): see the section "Storage element table" for further details, default empty hash
* **creamce::queues** (_hash_): see the section "Queues table" for further details, default empty hash
* **creamce::workarea::shared** (_boolean_): True if the working area is shared across different Execution Environment instances,
typically via an NFS mount; this attribute applies to single-slot jobs, default false
* **creamce::workarea::guaranteed** (_boolean_): True if the job is guaranteed the full extent of the WorkingAreaTotal;
this attribute applies to single-slot jobs, default false
* **creamce::workarea::total** (_integer_): Total size in GB of the working area available to all single-slot jobs, default 0
* **creamce::workarea::free** (_integer_): The amount of free space in GB currently available in the working area 
to all single-slot jobs, default 0 GB
* **creamce::workarea::lifetime** (_integer_): The minimum guaranteed lifetime in seconds of the files created by single-slot jobs 
in the working area, default 0 seconds
* **creamce::workarea::mslot_total** (_integer_): The total size in GB of the working area available to all the multi-slot Grid jobs
shared across all the Execution Environments, default 0GB
* **creamce::workarea::mslot_free** (_integer_): The amount of free space in GB currently available in the working area  to all multi-slot jobs
shared across all the Execution Environments, default 0 GB
* **creamce::workarea::mslot_lifetime** (_integer_): The minimum guaranteed lifetime in seconds of the files created by multi-slot jobs
in the working area, default 0 seconds

#### Hardware table
The hardware table is a hash with the following structure:
* the key of an entry in the table is the ID assigned to the homogeneous sub-cluster of machines (see GLUE2 execution environment).
* the value of an entry in the table is a hash containing the definitions for the homogeneous sub-cluster, the supported keys are:
 * **ce_cpu_model** (_string_): The name of the physical CPU model, as defined by the vendor, for example "XEON", **mandatory**
 * **ce_cpu_speed** (_integer_): The nominal clock speed of the physical CPU, expressed  in MHz, **mandatory**
 * **ce_cpu_vendor** (_string_): The name of the physical CPU vendor, for example "Intel", **mandatory**
 * **ce_cpu_version** (_string_): The specific version of the Physical CPU model as defined by the vendor, **mandatory**
 * **ce_physcpu** (_integer_): The number of physical CPUs (sockets) in a work node of the sub-cluster, **mandatory**
 * **ce_logcpu** (_integer_): The number of logical CPUs (cores) in a worker node of the sub-cluster, **mandatory**
 * **ce_minphysmem** (_integer_): The total amount of physical RAM in a worker node of the sub-cluster, expressed in MB, **mandatory**
 * **ce_minvirtmem** (_integer_): The total amount of virtual memory (RAM and swap space) in a worker node of the sub-cluster, expressed in MB
 * **ce_os_family** (_string_): The general family of the Operating System installed in a worker node ("linux", "macosx", "solaris", "windows"), **mandatory**
 * **ce_os_name** (_string_): The specific name Operating System installed in a worker node, for example "RedHat", **mandatory**
 * **ce_os_arch** (_string_): The platform type of worker node, for example "x86_64", **mandatory**
 * **ce_os_release** (_string_): The version of the Operating System installed in a worker node, as defined by the vendor, for example "7.0.1406", **mandatory**
 * **ce_outboundip** (_boolean_): True if a worker node has out-bound connectivity, false otherwise, default true
 * **ce_inboundip** (_boolean_): True if a worker node has in-bound connectivity, false otherwise default false
 * **ce_runtimeenv** (_list_): The list of tags associated to the software packages installed in the worker node,
the definitions for a tag is listed in the software table, default empty list
 * **ce_benchmarks** (_hash_): The hash table containing the values of the standard benchmarks ("specfp2000", "specint2000", "hep-spec06");
each key of the table corresponds to the benchmark name, default empty hash
 * **subcluster_tmpdir** (_string_): The path of a temporary directory shared across worker nodes (see GLUE 1.3)
 * **subcluster_wntmdir** (_string_): The path of a temporary directory local to each worker node (see GLUE 1.3)
 * **nodes** (_list_): The list of the name of the worker nodes of the sub-cluster, **mandatory**

#### Software table
The software table is a hash with the following structure:
* the key of an entry in the table is the tag assigned to the software installed on the machines (see GLUE2 application environment);
tags are used as a reference (**ce_runtimeenv**) in the hardware table.
* the value of an entry in the table is a hash containing the definitions for the software installed on the machines,
the supported keys are:
 * **name** (_string_): The name of the software installed, for example the package name, **mandatory**
 * **version** (_string_): The version of the software installed, **mandatory**
 * **license** (_string_): The license of the software installed, default unpublished
 * **description** (_string_): The description of the software installed, default unpublished

#### Queues table
The queues table is a hash with the following structure:
* the key of an entry in the table is the name of the batch system queue/partition
* the value of an entry in the table is a hash table containing the definitions for the related queue/partition,
the supported keys for definitions are:
 * **groups** (_list_): The list of local groups which are allowed to operate the queue/partition, each group MUST BE defined in the VO table
 * TODO definitions for SLURM

#### Storage element table
The storage element table is a hash with the following structure:
* the key of an entry in the table is the name of the storage element host
* the value of an entry in the table is a hash table containing the definitions for the related storage element,
the supported keys for definitions are:
 * **type** (_string_): The name of the application which is installed in the storage element ("Storm", "DCache", etc.)
 * **mount_dir** (_string_): The local path within the Computing Service which makes it possible to access files in the
associated Storage Service (this is typically an NFS mount point)
 * **export_dir** (_string_): The remote path in the Storage Service which is associated to the local path in the Computing
Service (this is typically an NFS exported directory).

### CREAM security
* **creamce::host_certificate** (_string_): The complete path of the installed host certificate, default /etc/grid-security/hostcert.pem
* **creamce::host_private_key** (_string_): The complete path of the installed host key, default /etc/grid-security/hostkey.pem
* **creamce::voms_dir** (_string_): The location for the deployment of VO description files (LSC), default /etc/grid-security/vomsdir
* **creamce::gridmap_dir** (_string_): The location for the pool account files, default /etc/grid-security/gridmapdir
* **creamce::gridmap_file** (_string_): The location of the pool account description file, default /etc/grid-security/grid-mapfile
* **creamce::gridmap_extras** (_list_): The list of custom entry for the pool account description file, default empty list
* **creamce::gridmap_cron_sched** (_string_): The time parameters for the pool account cleaner, default "5 * * * *"
* **creamce::groupmap_file** (_string_): The path of the groupmap file, default /etc/grid-security/groupmapfile
* **creamce::crl_update_time** (_integer_): The CRL refresh time in seconds, default 3600 seconds
* **creamce::ban_list_file** (_string_): The path of the ban list file, if gJAF/LCMAPS is used, default /etc/lcas/ban_users.db'
* **creamce::use_argus** (_boolean_): True if Argus authorization framework must be used, false if gJAF must be used, default true
* **creamce::argus::service"** (_string_): The argus PEPd service host name, **mandatory** if **creamce::user_argus** is set to true
* **creamce::argus::port** (_integer_): The Argus PEPd service port, default 8154
* **creamce::argus::timeout** (_integer_): The connection timeout in seconds for the connection to the Argus PEPd server, default 30 seconds
* **creamce::argus::resourceid** (_string_): The ID of the CREAM service to be registered in Argus, default "https://{ce_host}:{ce_port}/cream"
* **creamce::admin::list** (_list_): The list of service administators Distinguished Name, default empty list
* **creamce::admin::list_file** (_string_): The path of the file containing the service administrators list, default /etc/grid-security/admin-list
* **creamce::vo_table** (_hash_): see the section "VO table" for further details, default empty hash

#### VO table
The VO table is a hash, the key of an entry in the table is the name or ID of the virtual organization, 
the corresponding value is a hash table containing the definitions for the virtual organization,the supported keys for definitions are:
* **servers** (_list_): The list of VOMS servers, **mandatory**, each item in the list is a hash with the following keys:
  * **server** (_string_): The VOMS server FQDN, **mandatory**
  * **port** (_integer_): The VOMS server port, **mandatory**
  * **dn** (_string_): The distinguished name of the VOMS server, as declared in the VOMS service certificate, **mandatory**
  * **ca_dn** (_string_): The distinguished name of the issuer of the VOMS service certificate, **mandatory**
* **groups** (_hash_): The list of local groups and associated FQANs, **mandatory**, each key of the hash is the group name,
each value is a hash with the following keys:
  * **gid** (_string_): The unix group id, **mandatory**
  * **fqan** (_list_): The list of VOMS Fully Qualified Attribute Name, **mandatory**
  * **pub_admin** (_boolean_): True if the group is the defined administrator group, default false,
just one administrator group is supported
* **users** (_hash_): The description of the pool account, **mandatory**, each key of the hash is the pool account prefix,
each value is a hash with the following keys:
  * **first_uid** (_integer_): The initial number for the unix user id of the pool account, **mandatory**, the other ids are
obtained incrementally (step 1)
  * **name_pattern** (_list_): The pattern used to create the user name of the pool account, the variables used for the 
substitutions are "prefix", the pool account prefix, and "index", the current user id; the expression is described in
https://ruby-doc.org/core-2.2.0/Kernel.html#method-i-sprintf, default value is `%<prefix>s%03<index>d`
  * **groups** (_list_): The list of group for the current account, **mandatory**, the first element of the list is
the primary group, each element must be defined in **groups**
  * **pool_size** (_integer_): The number of user in the current pool account, the default value is global definition
contained into **creamce::default_pool_size**
* **vo_sw_dir** (_string_): Th base directory for installation of the software used by the current Virtual Organization
* **vo_app_dir** (_string_): The path of a shared directory available for application data for the current Virtual Organization,
as describe by Info.ApplicationDir in GLUE 1.3. 
* **vo_default_se** (_string_): The default Storage Element associated with the current Virtual Organization.
It must be one of the key of the storage element table

### GridFTP configuration

For the configuration of the GridFTP service installed on the CREAM CE refer to https://forge.puppet.com/lcgdm/gridftp

### CREAM on TORQUE

The TORQUE cluster must be install before the deployment of CREAM, there's no support in the CREAM CE puppet module for the
deployment of TORQUE. Nevertheless the module may be used to configure the TORQUE client on CREAM CE node if and only if 
the node is different from the TORQUE server node. The YAML parameter which enables the TORQUE client configuration is
**torque::config::client**, if it is set to **false** the configuration is disabled, the default value is **true**.
The CREAM CE puppet module can create queues and pool accounts in TORQUE, the YAML parameter is **torque::config::pool**,
if it is set to **false** the feature is disabled, the default value is **true**.

#### TORQUE configuration parameters

* **torque::host** (_string_): The TORQUE server host name, default the host name
* **torque::multiple_staging** (_boolean_): The BLAH parameter for multiple staging, default false
* **torque::tracejob_logs** (_integer_): The BLAH parameter for tracejob, default 2
* **torque::use_maui** (_boolean_): If true the support for maui is enabled, default false
* **munge::key_path** (_string_): The location of the munge key. If TORQUE client configuration is enabled the path is used
to retrieve the manually installed key; **mandatory** if **torque::config::client** is set to true.

### CREAM on HTCondor

TODO

### CREAM on SLURM

TODO

## Example of stand-alone installation and configuration for CentOS 7

### Puppet setup

Install EPEL extension: `yum -y install epel-release`

Install puppet: `yum -y install puppet`

Check if the hostname and FQDN is correctly detected by puppet:
```
facter | grep hostname
facter | grep fqdn
```
In the following examples the FQHN will be myhost.mydomain

Install the CREAM CE module for puppet: `puppet module install infnpd-creamce`

Apply the patch described in the tips&tricks section

Create the required directories: `mkdir -p /etc/puppet/manifests /var/lib/hiera/node`

Edit the file `/etc/puppet/manifests/site.pp` as:
```
node 'myhost.mydomain' {
  require creamce
}
```

Edit the file `/etc/hiera.yaml` as:
```
---
:backends:
  - yaml
:hierarchy:
  - "node/%{fqdn}"
:yaml:
  :datadir: /var/lib/hiera
```

Link the hiera configuration to puppet: `ln -s /etc/hiera.yaml /etc/puppet/hiera.yaml`

Edit the CREAM CE description file, an example of minimal configuration is:
```
---
creamce::mysql::root_password :      mysqlp@$$w0rd
creamce::creamdb::password :         creamp@$$w0rd
creamce::creamdb::minpriv_password : minp@$$w0rd
apel::db::pass :                     apelp@$$w0rd
creamce::batch_system :              pbs
creamce::use_argus :                 false
creamce::default_pool_size :         10
creamce::info::capability :          [ "CloudSupport=false", "Multinode=true" ]

creamce::repo_urls :                 [ "http://igi-01.pd.infn.it/mrepo/grid-dev/rpms/repos/centos7/emi-all.repo" ]

gridftp::params::certificate :       "/etc/grid-security/hostcert.pem"
gridftp::params::key :               "/etc/grid-security/hostkey.pem"
gridftp::params::port :              2811

creamce::queues :
    long :  { groups : [ dteam, dteamprod ] }
    short : { groups : [ dteamsgm ] }

creamce::vo_table :
    dteam : { 
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
            dteam : { fqan : [ "/dteam" ], gid : 9000 },
            
            dteamsgm : { fqan : [ "/dteam/sgm/ROLE=developer" ], gid : 9001, pub_admin : true },
            
            dteamprod : { fqan : [ "/dteam/prod/ROLE=developer" ], gid : 9002 }
        },
        users : {
            dteamusr : { first_uid : 6000, groups : [ dteam ], name_pattern : "%<prefix>s%03<index>d" },
            
            dteamsgmusr : { first_uid : 6100, groups : [ dteamsgm, dteam ], pool_size : 5, name_pattern : "%<prefix>s%02<index>d" },
            
            dteamprodusr : { first_uid : 6200, groups : [ dteamprod, dteam ], pool_size : 5, name_pattern : "%<prefix>s%02<index>d" }
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
        ce_minphysmem : 2048,
        ce_minvirtmem : 4096,
        ce_os_family : "linux",
        ce_os_name : "CentOS",
        ce_os_arch : "x86_64",
        ce_os_release : "7.0.1406",
        ce_outboundip : true,
        ce_inboundip : false,
        ce_runtimeenv : [ "tomcat_6_0", "mysql_5_1" ],
        subcluster_tmpdir : /var/tmp/subcluster001,
        subcluster_wntmdir : /var/glite/subcluster001,
        ce_benchmarks : { specfp2000 : 420, specint2000 : 380, hep-spec06 : 780 },
        nodes : [ "node-01.mydomain", "node-02.mydomain", "node-03.mydomain" ]
    }

creamce::software_table :
    tomcat_6_0 : {
        name : "tomcat",
        version : "6.0.24",
        license : "ASL 2.0",
        description : "Tomcat is the servlet container" 
    }
    mysql_5_1 : {
        name : "mysql",
        version : "5.1.73",
        license : "GPLv2 with exceptions",
        description : "MySQL is a multi-user, multi-threaded SQL database server" 
    }

creamce::se_table :
    storage.pd.infn.it : { mount_dir : "/data/mount", export_dir : "/storage/export", type : Storm }
    cloud.pd.infn.it : { mount_dir : "/data/mount", export_dir : "/storage/export",  type : Dcache }
```

Create the directory for credential: `mkdir -p /etc/grid-security`

Deploy the host key in `/etc/grid-security/hostkey.pem`

Deploy the host certificate in `/etc/grid-security/hostcert.pem`

Run puppet: `puppet apply --verbose /etc/puppet/manifests/site.pp`

## Tips, tricks and work-arounds

* The puppet module for BDII contains a misleading definition;
the line ```include bdii::firewall``` in the file /etc/puppet/modules/bdii/manifests/init.pp must be removed

