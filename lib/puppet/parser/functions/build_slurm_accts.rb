module Puppet::Parser::Functions

  newfunction(:build_slurm_accts, :type => :rvalue, :doc => "It returns the table of slurm accounts") do | args |
    voenv = args[0]
    type = args[1]
    deps = args[2]
    subs = args[3]
    
    result = Hash.new
    
    voenv.each do | voname, vodata |
    
      if type == "top"

        result["acct_#{voname}"] = Hash[
          "acct"          => voname,
          "dep_resources" => deps,
          "sub_resources" => subs
        ]

      else

        vodata['groups'].each do | gname, gdata |
          if gname != voname
            result["acct_#{gname}"] = Hash[
              "acct"          => gname,
              "p_acct"        => voname,
              "dep_resources" => deps,
              "sub_resources" => subs
            ]
          end
        end 

      end

    end
    
    return result
  
  end
  
end
