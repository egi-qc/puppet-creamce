module Puppet::Parser::Functions
  newfunction(:build_user_definitions, :type => :rvalue, :doc => "This function converts user table structure") do | args |
    voenv = args[0]
    gridmapdir = args[1]
    def_pool_size = args[2].to_i()
    def_name_offset = args[3].to_i()

    result = Hash.new

    voenv.each do | voname, vodata |

      f_table = Hash.new
      vodata['groups'].each do | group, gdata |
        gdata['fqan'].each do | fqan |

          norm_fqan = fqan.lstrip
          norm_fqan.slice!(/\/capability=null/i)
          norm_fqan.slice!(/\/role=null/i)
          norm_fqan.gsub!(/role=/i, "Role=")

          if f_table.has_key?(norm_fqan)
            raise "Duplicate definition of #{norm_fqan} for group #{group}"
          else
            f_table[norm_fqan] = group
          end

        end
      end

      vodata['users'].each do | user_prefix, udata |

        grp_list = Array.new
        udata['fqan'].each do | fqan |
          norm_fqan = fqan.lstrip
          norm_fqan.slice!(/\/capability=null/i)
          norm_fqan.slice!(/\/role=null/i)
          norm_fqan.gsub!(/role=/i, "Role=")
          unless f_table.has_key?(norm_fqan)
            raise "FQAN mismatch with #{norm_fqan} for #{user_prefix}"
          end
          grp_list.push(f_table[norm_fqan])
        end

        home_dir = udata.fetch('homedir', '/home')
        use_shell = udata.fetch('shell', '/bin/bash')
        name_pattern = udata.fetch('name_pattern', '%<prefix>s%03<index>d')
        comment_pattern = udata.fetch('comment_pattern', "")
        name_offset = udata.fetch('name_offset', def_name_offset)

        utable = udata.fetch('users_table', Hash.new)
        if utable.size > 0
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
          next
        end

        uid_list = udata.fetch('uid_list', Array.new)
        if uid_list.size > 0
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
          next
        end

        pool_size = udata.fetch('pool_size', def_pool_size)
        if pool_size > 0

          (0...pool_size).each do | idx |
            nDict = { :prefix => user_prefix, :index => (idx + name_offset) }
            nameStr = sprintf(name_pattern % nDict )
            commentStr = sprintf(comment_pattern % nDict )
            result[nameStr] = { 
              'uid'        => udata['first_uid'] + idx,
              'groups'     => grp_list,
              'gridmapdir' => "#{gridmapdir}",
              'comment'    => "#{commentStr}",
              'homedir'    => "#{home_dir}",
              'shell'      => "#{use_shell}"
            }

          end
        else
          # static account
          nDict = { :username => user_prefix, :userid => udata['first_uid'] }
          commentStr = sprintf(comment_pattern % nDict )
          result["#{user_prefix}"] = { 
            'uid'        => udata['first_uid'],
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

