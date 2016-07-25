module Puppet::Parser::Functions
  newfunction(:build_sudo_table, :type => :rvalue, :doc => "This function converts user table structure") do |args|
    voenv = args[0]

    result = Hash.new
    
    voenv.each do | voname, vodata |
      gItem = Hash.new
      vodata['groups'].each do | group, gdata |
        norm_group = group.upcase.tr("^A-Z0-9_", "_")
        gItem[norm_group] = Array.new
        vodata['users'].each do | user_prefix, udata |
          if udata["groups"][0] == group
            (udata['first_uid']...(udata['first_uid'] + udata['pool_size'])).each do | idx |
              gItem[norm_group].push("#{user_prefix}#{idx}")
            end
          end
        end
      end
      result[voname] = gItem
    end
    
    return result

  end
end

