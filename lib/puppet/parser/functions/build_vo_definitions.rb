require 'gridutils'

module Puppet::Parser::Functions
  newfunction(:build_vo_definitions, :type => :rvalue, :doc => "This function converts vo table structure") do | args |
    voenv = args[0]
    vodir = args[1]
    
    result = Hash.new
    idx = 0
    voenv.each do | voname, vodata |
      vodata[Gridutils::VO_SERVERS_T].each do | voitem |

        result["#{voname}_#{idx}"] = { 
          'server'    => voitem[Gridutils::VO_SRVNAME_T],
          'port'      => voitem[Gridutils::VO_SRVPORT_T],
          'dn'        => voitem[Gridutils::VO_SRVDN_T],
          'ca_dn'     => voitem[Gridutils::VO_SRVCADN_T],
          'gtversion' => voitem.fetch(Gridutils::VO_GTVER_T, '24'),
          'voname'    => voname,
          'vodir'     => vodir
        }

        idx += 1
      end
    end
    return result
  end
end

