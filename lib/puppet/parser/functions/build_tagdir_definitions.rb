require 'gridutils'

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
      
      f_table = Gridutils.get_fqan_table(vodata)
      
      vodata[Gridutils::USERS_T].each do | user_prefix, udata |
        if udata.fetch(Gridutils::USERS_PADMIN_T, false)

          name_pattern = udata.fetch(Gridutils::USERS_NPATTERN_T, Gridutils::USR_STRFMT_D)
          pool_size = udata.fetch(Gridutils::USERS_PSIZE_T, 1) # we can use 1 instead of def_pool_size
          utable = udata.fetch(Gridutils::USERS_UTABLE_T, nil)
          uid_list = udata.fetch(Gridutils::USERS_IDLIST_T, nil)

          if utable != nil and utable.size > 0
            tmp_list = utable.keys
            tmp_list.sort!
            admin_user = tmp_list[0]
          elsif (uid_list != nil and uid_list.size > 0) or pool_size > 0
            admin_user = sprintf(name_pattern % { :prefix => user_prefix, :index => name_offset })
          else
            admin_user = user_prefix
          end

          p_fqan = Gridutils.norm_fqan(udata[Gridutils::USERS_PFQAN_T][0])
          admin_group = f_table[p_fqan]
          break

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

