require 'gridutils'

module Puppet::Parser::Functions
  newfunction(:get_clusters_list, :type => :rvalue, :doc => "This function returns a list of subcluster data") do |args|
    subclusters = args[0]
    glue21_draft = args[1]
    
    result = Array.new

    subclusters.each do | res_id, res_info |
      
      cdata = Hash.new
      
      cdata["id"] = res_id
      
      cdata["physcpu_perhost"] = res_info.fetch(Gridutils::CE_PHYCPU_T, nil)
      if cdata["physcpu_perhost"] == nil
        raise "Wrong or missing cluster parameter: #{Gridutils::CE_PHYCPU_T}"
      end
      
      cdata["logcpu_perhost"] = res_info.fetch(Gridutils::CE_LOGCPU_T, nil)
      if cdata["logcpu_perhost"] == nil
        raise "Wrong or missing cluster parameter: #{Gridutils::CE_LOGCPU_T}"
      end
      
      cdata["wn_list"] = res_info.fetch(Gridutils::CE_NODES_T, ["ghost"])
      
      cdata["runtimeenv"] = res_info.fetch(Gridutils::CE_RTENV_T, [])
      
      cdata["cpu_model"] = res_info.fetch(Gridutils::CE_CPUMODEL_T, nil)
      if  cdata["cpu_model"] == nil
        raise "Wrong or missing cluster parameter: #{Gridutils::CE_CPUMODEL_T}"
      end
      
      cdata["cpu_speed"] = res_info.fetch(Gridutils::CE_CPUSPEED_T, nil)
      if cdata["cpu_speed"] == nil
        raise "Wrong or missing cluster parameter: #{Gridutils::CE_CPUSPEED_T}"
      end
      
      cdata["cpu_vendor"] = res_info.fetch(Gridutils::CE_CPUVEND_T, nil)
      if cdata["cpu_vendor"] == nil
        raise "Wrong or missing cluster parameter: #{Gridutils::CE_CPUVEND_T}"
      end
      
      cdata["cpu_version"] = res_info.fetch(Gridutils::CE_CPUVER_T, nil)
      if cdata["cpu_version"] == nil
        raise "Wrong or missing cluster parameter: #{Gridutils::CE_CPUVER_T}"
      end
      
      cdata["inboundip"] = res_info.fetch(Gridutils::CE_INCONN_T, "false")
      cdata["outboundip"] = res_info.fetch(Gridutils::CE_OUTCONN_T, "true")
      
      cdata["minphysmem"] = res_info.fetch(Gridutils::CE_PHYMEM_T, nil)
      if cdata["minphysmem"] == nil
        raise "Wrong or missing cluster parameter: #{Gridutils::CE_PHYMEM_T}"
      end
      
      cdata["minvirtmem"] = res_info.fetch(Gridutils::CE_VIRTMEM_T, cdata["minphysmem"])
      
      cdata["os_family"] = res_info.fetch(Gridutils::CE_OSFAMILY_T, nil)
      if cdata["os_family"] == nil
        raise "Wrong or missing cluster parameter: #{Gridutils::CE_OSFAMILY_T}"
      else
        cdata["os_family"]= cdata["os_family"].downcase
      end
      
      cdata["os_name"] = res_info.fetch(Gridutils::CE_OSNAME_T, nil)
      if cdata["os_name"] == nil
        raise "Wrong or missing cluster parameter: #{Gridutils::CE_OSNAME_T}"
      end
      
      cdata["os_arch"] = res_info.fetch(Gridutils::CE_OSARCH_T, nil)
      if cdata["os_arch"] == nil
        raise "Wrong or missing cluster parameter: #{Gridutils::CE_OSARCH_T}"
      elsif cdata["os_arch"] == "x86_64"
        cdata["platform_type"] = "amd64"
      else
        cdata["platform_type"] = cdata["os_arch"]
      end
      
      cdata["os_release"] = res_info.fetch(Gridutils::CE_OSREL_T, nil)
      if cdata["os_release"] == nil
        raise "Wrong or missing cluster parameter: #{Gridutils::CE_OSREL_T}"
      end
      
      cdata["os_version"] = "#{cdata['os_release']}.dummy".split(".")[0]
      
      cdata["otherdescr"] = res_info.fetch(Gridutils::CE_OTHERD_T, "")
      cdata["tmpdir"] = res_info.fetch(Gridutils::CE_TMPDIR_T, "")
      cdata["wntmdir"] = res_info.fetch(Gridutils::CE_WNTMDIR_T, "")
    
      cdata["benchmarks"] = res_info.fetch(Gridutils::CE_BENCHM_T, {})
      unless cdata["benchmarks"].has_key?(Gridutils::BENCH_SPECFP_D)
        cdata["benchmarks"][Gridutils::BENCH_SPECFP_D] = nil
      end
      unless cdata["benchmarks"].has_key?(Gridutils::BENCH_SPECINT_D)
        cdata["benchmarks"][Gridutils::BENCH_SPECINT_D] = nil
      end

      cdata["instances"] = cdata.fetch("node_number", cdata["wn_list"].length)
      cdata["physcpu"] = cdata["physcpu_perhost"] * cdata["instances"]
      cdata["logcpu"] = cdata["logcpu_perhost"] * cdata["instances"]
      if cdata["physcpu_perhost"] == 0
        cdata["cores"] = 0
      else
        cdata["cores"] = cdata["logcpu_perhost"] / cdata["physcpu_perhost"]
      end
      if cdata["instances"] == 0
        cdata["smpsize"] = 0
      else
        cdata["smpsize"] = cdata["logcpu"]/cdata["instances"]
      end

      if cdata["otherdescr"] == ""
        cdata["full_otherdescr"] = "Cores=#{cdata['cores']}"
      else
        cdata["full_otherdescr"] = "Cores=#{cdata['cores']},#{cdata['otherdescr']}"
      end
      if cdata["benchmarks"].has_key?(Gridutils::BENCH_HEP_D)
        hepSpec06 = cdata["benchmarks"][Gridutils::BENCH_HEP_D]
        cdata["full_otherdescr"] =  "#{cdata['full_otherdescr']},Benchmark=#{hepSpec06}-HEP-SPEC06"
      end

      if cdata["physcpu"] > 1 and cdata["cores"] > 1
        cdata["multeplicity"] = "multicpu-multicore"
      elsif cdata["physcpu"] > 1 and cdata["cores"] == 1
        cdata["multeplicity"] = "multicpu-singlecore"
      elsif cdata["physcpu"] == 1 and cdata["cores"] > 1
        cdata["multeplicity"] = "singlecpu-multicore"
      else
        cdata["multeplicity"] = "singlecpu-singlecore"
      end
      
      if glue21_draft
        cdata["accelerators"] = res_info.fetch(Gridutils::CE_ACCELER_T, {})
      else
        cdata["accelerators"] = {}
      end
      
      result.push(cdata)
      
    end
    
    return result
  end
end

