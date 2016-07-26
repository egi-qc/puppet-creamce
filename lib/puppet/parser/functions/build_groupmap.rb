module Puppet::Parser::Functions
  newfunction(:build_groupmap, :type => :rvalue, :doc => "This function returns the groupmap list") do |args|
    voenv = args[0]
    
    fqanlist = Array.new
    result = Array.new
    
    voenv.each do | voname, vodata |
      vodata['groups'].each do | group, gdata |
        gdata['fqan'].each do | fqan |
        
          norm_fqan = fqan.gsub(/role=/i, "Role=").gsub(/null/i, "NULL")
          if norm_fqan.include? "NULL"
            # TODO
          else
            fqanlist.push(Array[norm_fqan, group])
          end
        end
      end
    end
    
    fqanlist.sort!.reverse!
    
    fqanlist.each do | item |
      unless item[0].include? "Role"
        result.push(Array["#{item[0]}/Role=NULL", item[1]])
      end
      result.push(item)
    end
    
    return result
    
  end
end

