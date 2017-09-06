module Puppet::Parser::Functions

  newfunction(:build_groupmap, :type => :rvalue, :doc => "This function returns the groupmap list") do | args |
    voenv = args[0]

    fqantable = Hash.new
    result = Array.new

    voenv.each do | voname, vodata |
      vodata['groups'].each do | group, gdata |
        gdata['fqan'].each do | fqan |
        
          norm_fqan = fqan.lstrip
          norm_fqan.slice!(/\/capability=null/i)
          norm_fqan.slice!(/\/role=null/i)
          norm_fqan.gsub!(/role=/i, "Role=")
          
          if fqantable.has_key?(norm_fqan)
            raise "Duplicate definition of #{norm_fqan} for group #{group}"
          else
            fqantable[norm_fqan] = group
          end
        end
      end
    end

    fqanlist = fqantable.keys
    fqanlist.sort!.reverse!
    
    fqanlist.each do | item |
      if item.include? "Role"
        result.push(Array["#{item}/Capability=NULL", fqantable[item]])
      else
        result.push(Array["#{item}/Role=NULL/Capability=NULL", fqantable[item]])
        result.push(Array["#{item}/Role=NULL", fqantable[item]])
      end
      result.push(Array["#{item}", fqantable[item]])
    end

    return result

  end
end

