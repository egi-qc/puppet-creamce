module Puppet::Parser::Functions
  newfunction(:build_vo_definitions, :type => :rvalue, :doc => "This function converts vo table structure") do |args|
    voenv = args[0]
    vodir = args[1]
    
    result = Hash.new
    idx = 0
    voenv.each do | voname, vodata |
      vodata['servers'].each do | voitem |
        result["#{voname}_#{idx}"] = { 'server'    => voitem['server'],
                                       'port'      => voitem['port'],
                                       'dn'        => voitem['dn'],
                                       'ca_dn'     => voitem['ca_dn'],
                                       'gtversion' => voitem.fetch('gt_version', '24'),
                                       'voname'    => voname,
                                       'vodir'     => vodir }
        idx += 1
      end
    end
    return result
  end
end

