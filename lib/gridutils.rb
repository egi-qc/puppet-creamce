module Gridutils

  GROUPS_T =           'groups'
  GROUPS_GID_T =       'gid'
  GROUPS_FQAN_T =      'fqan'
  GROUPS_PADMIN_T =    'pub_admin'

  USERS_T =            'users'
  USERS_FQAN_T =       'fqan'
  USERS_PSIZE_T =      'pool_size'
  USERS_IDLIST_T =     'uid_list'
  USERS_UTABLE_T =     'users_table'
  USERS_NPATTERN_T =   'name_pattern'
  USERS_FIRSTID_T =    'first_uid'
  USERS_NOFFSET_T =    'name_offset'
  USERS_HOMEDIR_T =    'homedir'
  USERS_SHELL_T =      'shell'
  USERS_CPATTERN_T =   'comment_pattern'
  USERS_ACCTS_T =      'accounts'
  
  QUEUES_GROUPS_T =    'groups'
  
  def Gridutils.norm_fqan(fqan)
    norm_fqan = fqan.lstrip
    norm_fqan.slice!(/\/capability=null/i)
    norm_fqan.slice!(/\/role=null/i)
    norm_fqan.gsub!(/role=/i, "Role=")
    norm_fqan
  end
  
  def Gridutils.get_fqan_table(vodata)

    f_table = Hash.new

    vodata[Gridutils::GROUPS_T].each do | group, gdata |
      gdata[Gridutils::GROUPS_FQAN_T].each do | fqan |

        norm_fqan = Gridutils.norm_fqan(fqan)

        if f_table.has_key?(norm_fqan)
          raise "Duplicate definition of #{norm_fqan} for group #{group}"
        else
          f_table[norm_fqan] = group
        end

      end
    end

    f_table

  end

end
