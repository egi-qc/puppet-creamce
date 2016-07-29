module Puppet::Parser::Functions
  newfunction(:build_vo_group_table, :type => :rvalue, :doc => "This function build vo to group relationship") do |args|
    voenv = args[0]
    
    result = Hash.new

    voenv.each do | voname, vodata |
      vodata['groups'].each do | group, gdata |
        result[group] = voname
      end
    end
    return result
  end
end

