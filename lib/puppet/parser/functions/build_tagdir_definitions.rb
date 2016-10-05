module Puppet::Parser::Functions
  newfunction(:build_tagdir_definitions, :type => :rvalue, :doc => "This function builds tagdir table structure") do |args|
    voenv = args[0]
    subclusters = args[1]
    tag_path = args[2]
    req_obj_list = args[3]
    
    result = Hash.new

    voenv.each do | voname, vodata |

      admin_group = nil
      admin_user = nil

      vodata['groups'].each do | group, gdata |
        if gdata.fetch('pub_admin', false)
          admin_group = group
          break
        end
      end
      
      if admin_group != nil
      
        vodata['users'].each do | user_prefix, udata |
          if udata['groups'][0] == admin_group
            name_pattern = udata.fetch('name_pattern', '%<prefix>s%03<index>d')
            admin_user = sprintf(name_pattern % { :prefix => user_prefix, :index => 0 })
          end
        end
        
      end
      
      if admin_user != nil
        subclusters.each do | sc_name, sc_data |
          result[voname] = {
            'pub_dir'     => tag_path,
            'sub_cluster' => sc_name,
            'a_owner'     => admin_user,
            'a_group'     => admin_group,
            'req_list'    => req_obj_list
          }
        end
      end
      
    end
    
    return result

  end
end

