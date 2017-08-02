module Puppet::Parser::Functions
  newfunction(:build_queue_vo_map, :type => :rvalue, :doc => "This function build queue to vogroup relationship") do |args|
    grid_queues = args[0]
    voenv = args[1]

    result = Hash.new
    
    grid_queues.each do | queue, qdata |
    
      result[queue] = Hash.new
      
      voenv.each do | voname, vodata |
      
        qdata['groups'].each do | group |
      
          if vodata['groups'].has_key?(group)
          
            unless result[queue].has_key?(voname)
              result[queue][voname] = Array.new
            end
          
            vodata['groups'][group]['fqan'].each do | fqan |
               result[queue][voname].push(fqan)
            end

          end

        end

      end

    end

    return result
  end
end

