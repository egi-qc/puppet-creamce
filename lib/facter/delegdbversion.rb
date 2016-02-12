Facter.add(:delegdbversion) do
    setcode do
        creampropfile='/etc/glite-ce-cream/service.properties'
        result = "undefined"
        if File.exists?(creampropfile)
            propFile = File.open(creampropfile)
            srvDefs = propFile.readlines
            propFile.close()
        
            for line in srvDefs do
                value = /delegationdb_version\s*=\s*([0-9]+.[0-9]+)/.match(line)
                if value
                    result = value[1]
                end
            end
            
        end
        result
    end
end
