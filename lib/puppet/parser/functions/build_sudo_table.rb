module Puppet::Parser::Functions
  newfunction(:build_sudo_table, :type => :rvalue, :doc => "This function converts user table structure") do | args |
    voenv = args[0]
    def_pool_size = args[1].to_i()
    name_offset = args[2].to_i()

    result = Hash.new

    voenv.each do | voname, vodata |

      gItem = Hash.new
      f_table = Hash.new
      
      vodata['groups'].each do | group, gdata |
      
        norm_group = group.upcase.tr("^A-Z0-9_", "_")
        
        gdata['fqan'].each do | fqan |
        
          norm_fqan = fqan.lstrip
          norm_fqan.slice!(/\/capability=null/i)
          norm_fqan.slice!(/\/role=null/i)
          norm_fqan.gsub!(/role=/i, "Role=")

          if f_table.has_key?(norm_fqan)
            raise "Duplicate definition of #{norm_fqan} for group #{group}"
          else
            f_table[norm_fqan] = norm_group
          end

        end
        
        gItem[norm_group] = Array.new
        
      end

      vodata['users'].each do | user_prefix, udata |

        p_fqan = udata['fqan'][0].lstrip
        p_fqan.slice!(/\/capability=null/i)
        p_fqan.slice!(/\/role=null/i)
        p_fqan.gsub!(/role=/i, "Role=")

        norm_group = f_table[p_fqan]
        
        pool_size = udata.fetch('pool_size', def_pool_size)
        name_pattern = udata.fetch('name_pattern', '%<prefix>s%03<index>d')
        utable = udata.fetch('users_table', nil)
        uid_list = udata.fetch('uid_list', nil)
        
        if utable != nil and utable.size > 0

          gItem[norm_group].concat(utable.keys)

        elsif uid_list != nil and uid_list.size > 0

          (0...uid_list.size).each do | idx |
            nameStr = sprintf(name_pattern % { :prefix => user_prefix, :index => (idx + name_offset) })
            gItem[norm_group].push(nameStr)
          end

        elsif pool_size > 0

          (0...pool_size).each do | idx |
            nameStr = sprintf(name_pattern % { :prefix => user_prefix, :index => (idx + name_offset) })
            gItem[norm_group].push(nameStr)
          end

        else
          # static account
          gItem[norm_group].push("#{user_prefix}")
        end
      end

      result[voname] = gItem

    end
    
    return result

  end
end

