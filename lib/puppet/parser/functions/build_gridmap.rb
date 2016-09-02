module Puppet::Parser::Functions
  newfunction(:build_gridmap, :type => :rvalue, :doc => "This function returns the gridmap list") do |args|
    voenv = args[0]
    def_pool_size = args[1]
    
    result = Array.new
    fqanlist = Array.new
    
    voenv.each do | voname, vodata |
      vodata['users'].each do | user, udata |
        vodata['groups'][udata['groups'][0]]['fqan'].each do | fqan |
        
          norm_fqan = fqan.gsub(/role=/i, "Role=").gsub(/null/i, "NULL")
          if norm_fqan.include? "NULL"
            # TODO
          else
            if udata.fetch('pool_size', def_pool_size.to_i) > 0
              fqanlist.push(Array[norm_fqan, ".#{user}"])
            else
              # static account
              fqanlist.push(Array[norm_fqan, user])
            end
          end
        end

      end
    end
    
    fqanlist.sort!.reverse!
    
    fqanlist.each do | item |
      if item[0].include? "Role"
        result.push(Array["#{item[0]}/Capability=NULL", item[1]])
      else
        result.push(Array["#{item[0]}/Role=NULL/Capability=NULL", item[1]])
        result.push(Array["#{item[0]}/Role=NULL", item[1]])
      end
      result.push(item)
    end
    
    return result
    
  end
end

