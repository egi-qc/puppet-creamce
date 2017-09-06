require 'gridutils'

module Puppet::Parser::Functions
  newfunction(:build_user_definitions, :type => :rvalue, :doc => "This function converts user table structure") do | args |
    voenv = args[0]
    gridmapdir = args[1]
    def_pool_size = args[2].to_i()
    def_name_offset = args[3].to_i()

    result = Hash.new

    voenv.each do | voname, vodata |

      f_table = Gridutils.get_fqan_table(vodata)

      vodata[Gridutils::USERS_T].each do | user_prefix, udata |

        grp_list = Array.new
        udata[Gridutils::USERS_FQAN_T].each do | fqan |

          norm_fqan = Gridutils.norm_fqan(fqan)
          unless f_table.has_key?(norm_fqan)
            raise "FQAN mismatch with #{norm_fqan} for #{user_prefix}"
          end
          grp_list.push(f_table[norm_fqan])

        end

        home_dir = udata.fetch(Gridutils::USERS_HOMEDIR_T, '/home')
        use_shell = udata.fetch(Gridutils::USERS_SHELL_T, '/bin/bash')
        name_pattern = udata.fetch(Gridutils::USERS_NPATTERN_T, '%<prefix>s%03<index>d')
        comment_pattern = udata.fetch(Gridutils::USERS_CPATTERN_T, "")
        name_offset = udata.fetch(Gridutils::USERS_NOFFSET_T, def_name_offset)

        utable = udata.fetch(Gridutils::USERS_UTABLE_T, nil)
        uid_list = udata.fetch(Gridutils::USERS_IDLIST_T, nil)
        pool_size = udata.fetch(Gridutils::USERS_PSIZE_T, def_pool_size)
        
        if utable != nil and utable.size > 0

          utable.each do | u_name, u_id |
            nDict = { :username => u_name, :userid => u_id }
            commentStr = sprintf(comment_pattern % nDict )
            result[u_name] = {
              'uid'        => u_id,
              'groups'     => grp_list,
              'gridmapdir' => "#{gridmapdir}",
              'comment'    => "#{commentStr}",
              'homedir'    => "#{home_dir}",
              'shell'      => "#{use_shell}"
            }
          end

        elsif uid_list != nil and uid_list.size > 0

          (0...uid_list.size).each do | idx |
            nDict = { :prefix => user_prefix, :index => (idx + name_offset) }
            nameStr = sprintf(name_pattern % nDict )
            commentStr = sprintf(comment_pattern % nDict )
            result[nameStr] = {
              'uid'        => uid_list.at(idx),
              'groups'     => grp_list,
              'gridmapdir' => "#{gridmapdir}",
              'comment'    => "#{commentStr}",
              'homedir'    => "#{home_dir}",
              'shell'      => "#{use_shell}"
            }
          end

        elsif pool_size > 0

          (0...pool_size).each do | idx |
            nDict = { :prefix => user_prefix, :index => (idx + name_offset) }
            nameStr = sprintf(name_pattern % nDict )
            commentStr = sprintf(comment_pattern % nDict )
            result[nameStr] = { 
              'uid'        => udata[Gridutils::USERS_FIRSTID_T] + idx,
              'groups'     => grp_list,
              'gridmapdir' => "#{gridmapdir}",
              'comment'    => "#{commentStr}",
              'homedir'    => "#{home_dir}",
              'shell'      => "#{use_shell}"
            }

          end

        else
          # static account
          nDict = { :username => user_prefix, :userid => udata[Gridutils::USERS_FIRSTID_T] }
          commentStr = sprintf(comment_pattern % nDict )
          result["#{user_prefix}"] = { 
            'uid'        => udata[Gridutils::USERS_FIRSTID_T],
            'groups'     => grp_list,
            'gridmapdir' => "#{gridmapdir}",
            'comment'    => "#{commentStr}",
            'homedir'    => "#{home_dir}",
            'shell'      => "#{use_shell}"
          }
        end
      end
    end

    return result

  end
end

