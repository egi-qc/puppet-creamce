module Puppet::Parser::Functions
  newfunction(:build_queue_group_tuples, :type => :rvalue, :doc => "This function returns a table of queue-group tuple") do |args|
    grid_queues = args[0]
    deps = args[1]

    result = Hash.new
    
    grid_queues.each do | queue, qdata |
      qdata['groups'].each do | group |
        result["#{queue}_#{group}"] = Hash["queue" => queue, "group" => group, "dep_resources" => deps]
      end
    end

    return result
  end
end

