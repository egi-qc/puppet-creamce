module Puppet::Parser::Functions
  newfunction(:build_user_definitions, :type => :rvalue, :doc => "This function converts user table structure") do |args|
    voenv = args[0]
    gridmapdir = args[1]
    def_pool_size = args[2]
    
    result = Hash.new
    
    voenv.each do | voname, vodata |
      vodata['users'].each do | user_prefix, udata |
        (udata['first_uid']...(udata['first_uid'] + udata.fetch('pool_size', def_pool_size))).each do | idx |
          result["#{user_prefix}#{idx}"] = { 
            'uid'        => udata['uid'],
            'groups'     => udata['groups'],
            'gridmapdir' => "#{gridmapdir}",
            'homedir'    => "#{udata.fetch('homedir', '/home')}",
            'shell'      => "#{udata.fetch('shell', '/bin/bash')}"
          }
        end
      end
    end
    
    return result

  end
end

