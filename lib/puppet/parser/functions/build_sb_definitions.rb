module Puppet::Parser::Functions
  newfunction(:build_sb_definitions, :type => :rvalue, :doc => "This function converts sandbox table structure") do |args|
    voenv = args[0]
    sb_path = args[1]
    req_obj_list = args[2]
    
    result = Hash.new
    
    voenv.each do | voname, vodata |
      vodata['groups'].each do | group, gdata |
        result["#{sb_path}/#{group}"] = {
          'ensure'    => "directory",
          'owner'     => "tomcat",
          'group'     => group,
          'mode'      => 0770,
          'require'   => req_obj_list,
        }
      end
    end
    
    return result

  end
end

