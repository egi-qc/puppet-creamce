require 'gridutils'

module Puppet::Parser::Functions

  newfunction(:build_slurm_accts, :type => :rvalue, :doc => "It returns the table of slurm accounts") do | args |
    voenv = args[0]
    type = args[1]

    result = Hash.new

    voenv.each do | voname, vodata |

      if type == "top"

        result["acct_#{voname}"] = {
          "acct" => voname,
        }

      else

        vodata[Gridutils::GROUPS_T].each do | gname, gdata |
          if gname != voname
            result["acct_#{gname}"] = {
              "acct"   => gname,
              "p_acct" => voname,
            }
          end
        end 

      end

    end

    return result

  end

end

