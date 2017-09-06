module Puppet::Parser::Functions
  newfunction(:build_gridmap, :type => :rvalue, :doc => "This function returns the gridmap list") do | args |
    voenv = args[0]
    def_pool_size = args[1].to_i()

    fqantable = Hash.new
    result = Array.new

    voenv.each do | voname, vodata |
      vodata['users'].each do | user, udata |

        if udata.has_key?('groups') and not udata.has_key?('fqan')
        	raise "Definition \"group\" is deprecated, use \"fqan\" for #{user}"
        end

      	norm_fqan = udata['fqan'][0].lstrip
      	norm_fqan.slice!(/\/capability=null/i)
      	norm_fqan.slice!(/\/role=null/i)
      	norm_fqan.gsub!(/role=/i, "Role=")

        utable = udata.fetch('users_table', nil)
        uid_list = udata.fetch('uid_list', nil)
        pool_size = udata.fetch('pool_size', def_pool_size)

        if (utable != nil and utable.size > 0) or (uid_list != nil and uid_list.size > 0) or pool_size > 0
          fqantable[norm_fqan] = ".#{user}"
        else
          # static account
          fqantable[norm_fqan] = user
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

