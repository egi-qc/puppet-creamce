require 'gridutils'

module Puppet::Parser::Functions

  newfunction(:build_slurm_users, :type => :rvalue, :doc => "It returns the table of slurm users") do | args |
    voenv = args[0]
    queues = args[1]
    def_pool_size = args[2].to_i()
    use_std_accts = args[3]
    def_name_offset = args[4].to_i()

    result = Hash.new

    partTable = Hash.new
    queues.each do | qname, qdata |
      qdata[Gridutils::QUEUES_GROUPS_T].each do | grpname |
        unless partTable.has_key?(grpname)
          partTable[grpname] = Set.new
        end
        partTable[grpname].add(qname)
      end
    end

    voenv.each do | voname, vodata |

      f_table = Gridutils.get_fqan_table(vodata)

      vodata[Gridutils::USERS_T].each do | user_prefix, udata |

        partSet = Set.new
        accounts = Array.new

        udata[Gridutils::USERS_FQAN_T].each do | fqan |
          norm_fqan = Gridutils.norm_fqan(fqan)
          grpname = f_table[norm_fqan]
          partSet.merge(partTable[grpname])
          accounts.push(grpname)
        end

        unless use_std_accts
          accounts = udata.fetch(Gridutils::USERS_ACCTS_T, nil)
        end

        if accounts == nil or accounts.size == 0
          raise "Missing accounts definition for #{user_prefix}"
        end

        utable = udata.fetch(Gridutils::USERS_UTABLE_T, nil)
        uid_list = udata.fetch(Gridutils::USERS_IDLIST_T, nil)
        pool_size = udata.fetch(Gridutils::USERS_PSIZE_T, def_pool_size)
        name_pattern = udata.fetch(Gridutils::USERS_NPATTERN_T, '%<prefix>s%03<index>d')
        name_offset = udata.fetch(Gridutils::USERS_NOFFSET_T, def_name_offset)

        if utable != nil and utable.size > 0

          utable.each do | u_name, u_id |
            result["acctusr_#{u_name}"] = {
              "pool_user"     => u_name,
              "accounts"      => accounts,
              "partitions"    => partSet.to_a(),
            }
          end

        elsif uid_list != nil and uid_list.size > 0

          (0...uid_list.size).each do | idx |
            nameStr = sprintf(name_pattern % { :prefix => user_prefix, :index => (idx + name_offset) })
            result["acctusr_#{nameStr}"] = {
              "pool_user"     => nameStr,
              "accounts"      => accounts,
              "partitions"    => partSet.to_a(),
            }
          end

        elsif pool_size > 0

          (0...pool_size).each do | idx |
            nameStr = sprintf(name_pattern % { :prefix => user_prefix, :index => (idx + name_offset) })
            result["acctusr_#{nameStr}"] = {
              "pool_user"     => nameStr,
              "accounts"      => accounts,
              "partitions"    => partSet.to_a(),
            }
          end

        else
          # static account
          result["acctusr_#{user_prefix}"] = {
              "pool_user"     => user_prefix,
              "accounts"      => accounts,
              "partitions"    => partSet.to_a(),
          }
        end
      end
    end

    return result

  end

end

