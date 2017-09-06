module Puppet::Parser::Functions
  newfunction(:build_tagdir_definitions, :type => :rvalue, :doc => "This function builds tagdir table structure") do | args |
    voenv = args[0]
    tag_path = args[1]
    name_offset = args[2].to_i()

    result = Hash.new

    voenv.each do | voname, vodata |

      admin_group = nil
      admin_user = nil
      admin_flist = Array.new

      vodata['groups'].each do | group, gdata |
        if gdata.fetch('pub_admin', false)
          admin_group = group
          gdata['fqan'].each do | fqan |
            norm_fqan = fqan.lstrip
            norm_fqan.slice!(/\/capability=null/i)
            norm_fqan.slice!(/\/role=null/i)
            norm_fqan.gsub!(/role=/i, "Role=")
            admin_flist.push(norm_fqan)
          end
          break
        end
      end
      
      if admin_group != nil
      
        vodata['users'].each do | user_prefix, udata |

          p_fqan = udata['fqan'][0].lstrip
          p_fqan.slice!(/\/capability=null/i)
          p_fqan.slice!(/\/role=null/i)
          p_fqan.gsub!(/role=/i, "Role=")

          if admin_flist.include?(p_fqan)

            name_pattern = udata.fetch('name_pattern', '%<prefix>s%03<index>d')
            pool_size = udata.fetch('pool_size', 1)
            utable = udata.fetch('users_table', nil)
            uid_list = udata.fetch('uid_list', nil)

            if utable != nil and utable.size > 0
              tmp_list = utable.keys
              tmp_list.sort!
              admin_user = tmp_list[0]
            elsif (uid_list != nil and uid_list.size > 0) or pool_size > 0
              admin_user = sprintf(name_pattern % { :prefix => user_prefix, :index => name_offset })
            else
              admin_user = user_prefix
            end
          end
        end

      end

      if admin_user != nil
        result[voname] = {
          'pub_dir'     => tag_path,
          'a_owner'     => admin_user,
          'a_group'     => admin_group
        }
      end

    end

    return result

  end
end

