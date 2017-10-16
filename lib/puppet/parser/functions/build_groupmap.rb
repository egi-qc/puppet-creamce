require 'gridutils'

module Puppet::Parser::Functions

  newfunction(:build_groupmap, :type => :rvalue, :doc => "This function returns the groupmap list") do | args |
    voenv = args[0]

    fqantable = Hash.new
    result = Array.new

    voenv.each do | voname, vodata |
    
      fqantable.merge!(Gridutils.get_fqan_table(vodata))

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

