require 'gridutils'

module Puppet::Parser::Functions
  newfunction(:build_gridmap, :type => :rvalue, :doc => "This function returns the gridmap list") do | args |
    voenv = args[0]
    def_pool_size = args[1].to_i()

    fqantable = Hash.new
    result = Array.new

    voenv.each do | voname, vodata |
      vodata[Gridutils::USERS_T].each do | user, udata |

        if udata.has_key?(Gridutils::USERS_FQAN_T)
        	raise "Definition \"fqan\" is deprecated, use \"primary_fqan\" for #{user}"
        end

        if udata.has_key?('groups')
        	raise "Definition \"groups\" is deprecated, use \"primary_fqan\" for #{user}"
        end

      	if udata.fetch(Gridutils::USERS_PFQAN_T, []).length == 0
          raise "Attribute #{Gridutils::USERS_PFQAN_T} is mandatory for #{user}"
        end

        if Gridutils.is_a_pool(udata, def_pool_size)
          udata[Gridutils::USERS_PFQAN_T].each do | pfqan |
            fqantable[Gridutils.norm_fqan(pfqan)] = ".#{user}"
          end
        else
          udata[Gridutils::USERS_PFQAN_T].each do | pfqan |
            fqantable[Gridutils.norm_fqan(pfqan)] = user
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

