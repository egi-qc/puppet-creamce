module Puppet::Parser::Functions
  newfunction(:build_group_definitions, :type => :rvalue, :doc => "This function converts group table structure") do |args|
    voenv = args[0]
    
    result = Hash.new
    gid_table = Hash.new

    voenv.each do | voname, vodata |
      vodata['groups'].each do | group, gdata |
        if gid_table.has_key?(gdata['gid'])
          raise "Duplicate gid #{gdata['gid']}"
        else
          gid_table[gdata['gid']] = gdata['fqan']
        end
        result[group] = { 'ensure'   => "present",
                          'tag'      => [ 'creamce::poolgroup' ],
                          'gid'      => gdata['gid']}
      end
    end
    return result
  end
end

