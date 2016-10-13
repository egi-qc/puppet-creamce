module Puppet::Parser::Functions
  newfunction(:get_clusters_list, :type => :rvalue, :doc => "This function returns a list of subcluster data") do |args|
    subclusters = args[0]
    glue21_draft = args[1]
    
    result = Array.new

    subclusters.each do | res_id, res_info |
      
      cdata = Hash.new
      
      cdata["id"] = res_id
      
      cdata["physcpu_perhost"] = res_info.fetch("ce_physcpu", nil)
      if cdata["physcpu_perhost"] == nil
        raise "Wrong or missing cluster parameter: ce_physcpu"
      end
      
      cdata["logcpu_perhost"] = res_info.fetch("ce_logcpu", nil)
      if cdata["logcpu_perhost"] == nil
        raise "Wrong or missing cluster parameter: ce_logcpu"
      end
      
      cdata["wn_list"] = res_info.fetch("nodes", ["ghost"])
      
      cdata["runtimeenv"] = res_info.fetch("ce_runtimeenv", [])
      
      cdata["cpu_model"] = res_info.fetch("ce_cpu_model", nil)
      if  cdata["cpu_model"] == nil
        raise "Wrong or missing cluster parameter: ce_cpu_model"
      end
      
      cdata["cpu_speed"] = res_info.fetch("ce_cpu_speed", nil)
      if cdata["cpu_speed"] == nil
        raise "Wrong or missing cluster parameter: ce_cpu_speed"
      end
      
      cdata["cpu_vendor"] = res_info.fetch("ce_cpu_vendor", nil)
      if cdata["cpu_vendor"] == nil
        raise "Wrong or missing cluster parameter: ce_cpu_vendor"
      end
      
      cdata["cpu_version"] = res_info.fetch("ce_cpu_version", nil)
      if cdata["cpu_version"] == nil
        raise "Wrong or missing cluster parameter: ce_cpu_version"
      end
      
      cdata["inboundip"] = res_info.fetch("ce_inboundip", "false")
      cdata["outboundip"] = res_info.fetch("ce_outboundip", "true")
      
      cdata["minphysmem"] = res_info.fetch("ce_minphysmem", nil)
      if cdata["minphysmem"] == nil
        raise "Wrong or missing cluster parameter: ce_minphysmem"
      end
      
      cdata["minvirtmem"] = res_info.fetch("ce_minvirtmem", cdata["minphysmem"])
      
      cdata["os_family"] = res_info.fetch("ce_os_family", nil)
      if cdata["os_family"] == nil
        raise "Wrong or missing cluster parameter: ce_os_family"
      else
        cdata["os_family"]= cdata["os_family"].downcase
      end
      
      cdata["os_name"] = res_info.fetch("ce_os_name", nil)
      if cdata["os_name"] == nil
        raise "Wrong or missing cluster parameter: ce_os_name"
      end
      
      cdata["os_arch"] = res_info.fetch("ce_os_arch", nil)
      if cdata["os_arch"] == nil
        raise "Wrong or missing cluster parameter: ce_os_arch"
      elsif cdata["os_arch"] == "x86_64"
        cdata["platform_type"] = "amd64"
      else
        cdata["platform_type"] = cdata["os_arch"]
      end
      
      cdata["os_release"] = res_info.fetch("ce_os_release", nil)
      if cdata["os_release"] == nil
        raise "Wrong or missing cluster parameter: ce_os_release"
      end
      
      cdata["os_version"] = "#{cdata['os_release']}.dummy".split(".")[0]
      
      cdata["otherdescr"] = res_info.fetch("ce_otherdescr", "")
      cdata["tmpdir"] = res_info.fetch("subcluster_tmpdir", "")
      cdata["wntmdir"] = res_info.fetch("subcluster_wntmdir", "")
    
      cdata["benchmarks"] = res_info.fetch("ce_benchmarks", {})
      unless cdata["benchmarks"].has_key?("specfp2000")
        cdata["benchmarks"]["specfp2000"] = nil
      end
      unless cdata["benchmarks"].has_key?("specint2000")
        cdata["benchmarks"]["specint2000"] = nil
      end

      cdata["instances"] = cdata["wn_list"].length
      cdata["smpsize"] = cdata["logcpu"]/cdata["instances"]
      cdata["physcpu"] = cdata["physcpu_perhost"] * cdata["instances"]
      cdata["logcpu"] = cdata["logcpu_perhost"] * cdata["instances"]
      cdata["cores"] = cdata["logcpu"]/cdata["physcpu"]

      if cdata["otherdescr"] == ""
        cdata["full_otherdescr"] = "Cores=#{cdata['cores']}"
      else
        cdata["full_otherdescr"] = "Cores=#{cdata['cores']},#{cdata['otherdescr']}"
      end
      if cdata["benchmarks"].has_key?("hep-spec06")
        hepSpec06 = cdata["benchmarks"]["hep-spec06"]
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
        cdata["accelerators"] = res_info.fetch("accelerators", {})
      else
        cdata["accelerators"] = {}
      end
      
      result.push(cdata)
      
    end
    
    return result
  end
end

